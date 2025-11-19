import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/forecast_provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';

/// Screen showing fishing forecast based on weather and solunar data
class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      _currentPosition = await Geolocator.getCurrentPosition();

      if (mounted) {
        await context.read<ForecastProvider>().loadForecast(
              latitude: _currentPosition!.latitude,
              longitude: _currentPosition!.longitude,
            );

        await context.read<ForecastProvider>().loadWeeklyForecast(
              latitude: _currentPosition!.latitude,
              longitude: _currentPosition!.longitude,
            );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabForecast ?? 'Fishing Forecast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCurrentLocation,
          ),
        ],
      ),
      body: Consumer<ForecastProvider>(
        builder: (context, provider, child) {
          if (_isLoadingLocation || provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading forecast',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCurrentLocation,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!provider.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No forecast available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Enable location to get forecast'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCurrentLocation,
                    child: const Text('Get Location'),
                  ),
                ],
              ),
            );
          }

          final forecast = provider.currentForecast!;

          return RefreshIndicator(
            onRefresh: _loadCurrentLocation,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Current forecast card
                _buildCurrentForecastCard(forecast, provider),
                const SizedBox(height: 16),

                // Fishing rating
                _buildFishingRatingCard(forecast, provider),
                const SizedBox(height: 16),

                // Solunar periods
                _buildSolunarCard(forecast),
                const SizedBox(height: 16),

                // Recommendations
                _buildRecommendationsCard(forecast),
                const SizedBox(height: 16),

                // 7-day forecast
                if (provider.weeklyForecast != null)
                  _buildWeeklyForecast(provider.weeklyForecast!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentForecastCard(forecast, ForecastProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  forecast.location,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getWeatherIcon(forecast.weather.condition),
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${forecast.weather.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              forecast.weather.description,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 24),
            _buildWeatherDetail('Wind', '${forecast.weather.windSpeed.toStringAsFixed(1)} m/s'),
            _buildWeatherDetail('Humidity', '${forecast.weather.humidity.toStringAsFixed(0)}%'),
            _buildWeatherDetail('Pressure', '${forecast.weather.pressure.toStringAsFixed(0)} hPa'),
          ],
        ),
      ),
    );
  }

  Widget _buildFishingRatingCard(forecast, ForecastProvider provider) {
    final rating = forecast.rating;
    final color = provider.getRatingColor(rating.score);
    final icon = provider.getRatingIcon(rating.score);

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 8),
                Text(
                  rating.rating,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fishing Score: ${rating.score}/100',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: rating.score / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolunarCard(forecast) {
    final solunar = forecast.solunar;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Solunar Forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(_getMoonPhaseIcon(solunar.moonPhase),
                        style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 4),
                    Text(
                      _getMoonPhaseName(solunar.moonPhase),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${(solunar.moonIllumination * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text('Illumination'),
                  ],
                ),
              ],
            ),
            if (solunar.majorPeriods.isNotEmpty) ...[
              const Divider(height: 24),
              const Text(
                'Best Fishing Times',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...solunar.majorPeriods.map((period) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${period.startTime.hour}:${period.startTime.minute.toString().padLeft(2, '0')} - '
                          '${period.endTime.hour}:${period.endTime.minute.toString().padLeft(2, '0')}',
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'MAJOR',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(forecast) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...forecast.recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(rec)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyForecast(List forecasts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '7-Day Forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...forecasts.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDate(f.timestamp)),
                      Text(_getWeatherIcon(f.weather.condition),
                          style: const TextStyle(fontSize: 24)),
                      Text('${f.weather.temperature.toStringAsFixed(0)}°C'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: context
                              .read<ForecastProvider>()
                              .getRatingColor(f.rating.score)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${f.rating.score}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'snow':
        return '❄️';
      case 'thunderstorm':
        return '⛈️';
      default:
        return '🌤️';
    }
  }

  String _getMoonPhaseIcon(moonPhase) {
    final phaseStr = moonPhase.toString().split('.').last;
    switch (phaseStr) {
      case 'newMoon':
        return '🌑';
      case 'waxingCrescent':
        return '🌒';
      case 'firstQuarter':
        return '🌓';
      case 'waxingGibbous':
        return '🌔';
      case 'fullMoon':
        return '🌕';
      case 'waningGibbous':
        return '🌖';
      case 'lastQuarter':
        return '🌗';
      case 'waningCrescent':
        return '🌘';
      default:
        return '🌙';
    }
  }

  String _getMoonPhaseName(moonPhase) {
    final phaseStr = moonPhase.toString().split('.').last;
    return phaseStr
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
        .trim();
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]} ${date.day}/${date.month}';
  }
}
