import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/fishing_spots_provider.dart';
import '../models/fishing_spot.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';

class FishingMapScreen extends StatefulWidget {
  const FishingMapScreen({super.key});

  @override
  State<FishingMapScreen> createState() => _FishingMapScreenState();
}

class _FishingMapScreenState extends State<FishingMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoadingLocation = false;

  // Default location (San Francisco)
  static const LatLng _defaultLocation = LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMarkers();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _loadMarkers() async {
    final spotsProvider = context.read<FishingSpotsProvider>();
    final spots = spotsProvider.fishingSpots;

    final markers = <Marker>{};
    for (final spot in spots) {
      markers.add(
        Marker(
          markerId: MarkerId('spot_${spot.id}'),
          position: LatLng(spot.latitude, spot.longitude),
          infoWindow: InfoWindow(
            title: spot.name,
            snippet: spot.fishSpecies ?? spot.description,
            onTap: () => _showSpotDetails(spot),
          ),
          icon: spot.isFavorite
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () => _showSpotDetails(spot),
        ),
      );
    }

    setState(() => _markers.addAll(markers));
  }

  void _showSpotDetails(FishingSpot spot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSpotDetailsSheet(spot),
    );
  }

  Widget _buildSpotDetailsSheet(FishingSpot spot) {
    final l10n = AppLocalizations.of(context)!;
    final spotsProvider = context.watch<FishingSpotsProvider>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radius16),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: AppDimensions.space8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(spot.name, style: AppTheme.h2),
                        ),
                        IconButton(
                          icon: Icon(
                            spot.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: spot.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            spotsProvider.toggleFavorite(spot.id!);
                          },
                        ),
                      ],
                    ),
                    if (spot.rating != null) ...[
                      const SizedBox(height: AppDimensions.space8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < spot.rating!
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                    if (spot.description != null) ...[
                      const SizedBox(height: AppDimensions.space16),
                      Text('Description', style: AppTheme.h4),
                      const SizedBox(height: AppDimensions.space8),
                      Text(spot.description!, style: AppTheme.body),
                    ],
                    if (spot.fishSpecies != null) ...[
                      const SizedBox(height: AppDimensions.space16),
                      Text('Fish Species', style: AppTheme.h4),
                      const SizedBox(height: AppDimensions.space8),
                      Text(spot.fishSpecies!, style: AppTheme.body),
                    ],
                    if (spot.waterType != null) ...[
                      const SizedBox(height: AppDimensions.space16),
                      _buildInfoRow('Water Type', spot.waterType!),
                    ],
                    if (spot.bestTimeToFish != null) ...[
                      const SizedBox(height: AppDimensions.space8),
                      _buildInfoRow('Best Time', spot.bestTimeToFish!),
                    ],
                    if (spot.accessInfo != null) ...[
                      const SizedBox(height: AppDimensions.space16),
                      Text('Access Info', style: AppTheme.h4),
                      const SizedBox(height: AppDimensions.space8),
                      Text(spot.accessInfo!, style: AppTheme.body),
                    ],
                    const SizedBox(height: AppDimensions.space24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _navigateToSpot(spot),
                            icon: const Icon(Icons.directions),
                            label: const Text('Directions'),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _shareSpot(spot),
                            icon: const Icon(Icons.share),
                            label: Text(l10n.shareResult),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              LatLng(spot.latitude, spot.longitude),
                              15,
                            ),
                          );
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text('Show on Map'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: AppTheme.bodySmall),
      ],
    );
  }

  void _navigateToSpot(FishingSpot spot) {
    // Open in maps app
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${spot.latitude},${spot.longitude}';
    debugPrint('Navigate to: $url');
    // url_launcher would be used here
  }

  void _shareSpot(FishingSpot spot) {
    final text = '''
Check out this fishing spot: ${spot.name}
${spot.description ?? ''}
Location: ${spot.latitude}, ${spot.longitude}
https://www.google.com/maps?q=${spot.latitude},${spot.longitude}
''';
    Share.share(text);
  }

  void _onMapLongPress(LatLng position) {
    _showAddSpotDialog(position);
  }

  void _showAddSpotDialog(LatLng position) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final speciesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Fishing Spot'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Spot Name *',
                  hintText: 'My Favorite Spot',
                ),
              ),
              const SizedBox(height: AppDimensions.space12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Great spot near the bridge',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppDimensions.space12),
              TextField(
                controller: speciesController,
                decoration: const InputDecoration(
                  labelText: 'Fish Species',
                  hintText: 'Bass, Trout, etc.',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                return;
              }

              final spot = FishingSpot(
                name: nameController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
                latitude: position.latitude,
                longitude: position.longitude,
                fishSpecies: speciesController.text.trim().isEmpty
                    ? null
                    : speciesController.text.trim(),
                dateAdded: DateTime.now(),
              );

              await context.read<FishingSpotsProvider>().addFishingSpot(spot);
              await _loadMarkers();

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fishing spot added!')),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fishing Spots Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : _defaultLocation,
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onLongPress: _onMapLongPress,
          ),
          if (_isLoadingLocation)
            const Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.space12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: AppDimensions.space12),
                        Text('Getting your location...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final center = _currentPosition != null
              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
              : _defaultLocation;
          _showAddSpotDialog(center);
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }

  void _showFilterDialog() {
    // Filter dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Fishing Spots'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter options coming soon!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }
}
