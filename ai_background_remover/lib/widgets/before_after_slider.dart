import 'dart:io';
import 'package:flutter/material.dart';

/// Widget for comparing before/after images with an interactive slider
class BeforeAfterSlider extends StatefulWidget {
  final File beforeImage;
  final File afterImage;
  final double initialPosition;
  final Color dividerColor;
  final double dividerWidth;
  final Widget? beforeLabel;
  final Widget? afterLabel;
  final bool showLabels;

  const BeforeAfterSlider({
    Key? key,
    required this.beforeImage,
    required this.afterImage,
    this.initialPosition = 0.5,
    this.dividerColor = Colors.white,
    this.dividerWidth = 3.0,
    this.beforeLabel,
    this.afterLabel,
    this.showLabels = true,
  }) : super(key: key);

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  late double _sliderPosition;

  @override
  void initState() {
    super.initState();
    _sliderPosition = widget.initialPosition;
  }

  void _updatePosition(double position) {
    setState(() {
      _sliderPosition = position.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final position = details.localPosition.dx / width;
            _updatePosition(position);
          },
          onTapDown: (details) {
            final position = details.localPosition.dx / width;
            _updatePosition(position);
          },
          child: Stack(
            children: [
              // After image (full width)
              Positioned.fill(
                child: Image.file(
                  widget.afterImage,
                  fit: BoxFit.contain,
                ),
              ),

              // Before image (clipped by slider position)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _sliderPosition * width,
                child: ClipRect(
                  child: Image.file(
                    widget.beforeImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Divider line
              Positioned(
                left: _sliderPosition * width - widget.dividerWidth / 2,
                top: 0,
                bottom: 0,
                width: widget.dividerWidth,
                child: Container(
                  color: widget.dividerColor,
                ),
              ),

              // Slider handle
              Positioned(
                left: _sliderPosition * width - 20,
                top: height / 2 - 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.dividerColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.drag_handle,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),

              // Labels
              if (widget.showLabels) ...[
                // Before label
                Positioned(
                  left: 16,
                  top: 16,
                  child: widget.beforeLabel ??
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Before',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                ),

                // After label
                Positioned(
                  right: 16,
                  top: 16,
                  child: widget.afterLabel ??
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'After',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
