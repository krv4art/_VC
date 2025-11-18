import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scan_provider.dart';
import '../../constants/app_dimensions.dart';
import '../../navigation/route_names.dart';

/// Scanner camera screen
/// Full-screen camera view for document scanning
class ScannerCameraScreen extends StatefulWidget {
  const ScannerCameraScreen({super.key});

  @override
  State<ScannerCameraScreen> createState() => _ScannerCameraScreenState();
}

class _ScannerCameraScreenState extends State<ScannerCameraScreen> {
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final scanProvider = context.read<ScanProvider>();
    await scanProvider.initializeCamera();
    await scanProvider.startScanSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<ScanProvider>(
        builder: (context, scanProvider, child) {
          if (!scanProvider.isCameraInitialized) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (scanProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: AppDimensions.space16),
                  Text(
                    scanProvider.error!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final controller = scanProvider.cameraController!;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera preview
              CameraPreview(controller),

              // Top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopBar(context, scanProvider),
              ),

              // Center guide overlay
              _buildGuideOverlay(),

              // Bottom controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomControls(context, scanProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ScanProvider scanProvider) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppDimensions.space8,
        left: AppDimensions.space16,
        right: AppDimensions.space16,
        bottom: AppDimensions.space16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () async {
              await scanProvider.cancelScanSession();
              if (context.mounted) context.pop();
            },
          ),

          const Spacer(),

          // Flash button
          IconButton(
            icon: Icon(
              scanProvider.flashMode == FlashMode.off
                  ? Icons.flash_off
                  : Icons.flash_on,
              color: Colors.white,
            ),
            onPressed: () => scanProvider.toggleFlash(),
          ),

          // Settings button
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: Show settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGuideOverlay() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppDimensions.space32),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        child: AspectRatio(
          aspectRatio: 1 / 1.414, // A4 ratio
          child: Container(),
        ),
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, ScanProvider scanProvider) {
    final session = scanProvider.currentSession;
    final pageCount = session?.pages.length ?? 0;

    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.space16,
        right: AppDimensions.space16,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.space16,
        top: AppDimensions.space16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Gallery button
          IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.white, size: 28),
            onPressed: () {
              // TODO: Import from gallery
            },
          ),

          // Capture button
          GestureDetector(
            onTap: scanProvider.isCapturing
                ? null
                : () async {
                    await scanProvider.capturePage();
                  },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: scanProvider.isCapturing
                    ? Colors.grey
                    : Colors.white.withOpacity(0.3),
              ),
              child: scanProvider.isCapturing
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : null,
            ),
          ),

          // Page count & done button
          if (pageCount > 0)
            GestureDetector(
              onTap: () async {
                final session = await scanProvider.finalizeScanSession();
                if (context.mounted && session != null) {
                  context.push(RouteNames.scanPreview);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Row(
                  children: [
                    Text(
                      '$pageCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            )
          else
            const SizedBox(width: 70), // Spacer to balance layout
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Provider will handle camera disposal
    super.dispose();
  }
}
