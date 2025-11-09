import 'package:flutter/material.dart';
import 'scanning_frame_painter.dart';
import '../../theme/app_theme.dart';

/// Camera scan overlay with scanning frame and instructions
class CameraScanOverlay extends StatefulWidget {
  final VoidCallback? onCapture;
  final VoidCallback? onFlashToggle;
  final bool flashOn;

  const CameraScanOverlay({
    super.key,
    this.onCapture,
    this.onFlashToggle,
    this.flashOn = false,
  });

  @override
  State<CameraScanOverlay> createState() => _CameraScanOverlayState();
}

class _CameraScanOverlayState extends State<CameraScanOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameSize = size.width * 0.75;

    return Stack(
      children: [
        // Dark overlay
        Container(
          color: Colors.black.withOpacity(0.5),
        ),

        // Scanning frame
        Center(
          child: SizedBox(
            width: frameSize,
            height: frameSize,
            child: CustomPaint(
              painter: ScanningFramePainter(
                color: Colors.white,
                strokeWidth: 3,
                cornerLength: 40,
              ),
            ),
          ),
        ),

        // Scanning line animation
        Center(
          child: SizedBox(
            width: frameSize,
            height: frameSize,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ScanLinePainter(
                    progress: _animation.value,
                    color: Colors.green.withOpacity(0.6),
                  ),
                );
              },
            ),
          ),
        ),

        // Instructions
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space16,
                vertical: AppTheme.space8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Text(
                'Position plant within frame',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Flash toggle
              IconButton(
                onPressed: widget.onFlashToggle,
                icon: Icon(
                  widget.flashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              // Capture button
              GestureDetector(
                onTap: widget.onCapture,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // Gallery button
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.photo_library,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScanLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final y = size.height * progress;
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
