import 'dart:io';
import 'package:flutter/material.dart';

/// A widget that displays a before/after comparison slider for two images
class BeforeAfterSlider extends Widget {
  final String beforeImagePath;
  final String afterImagePath;
  final double initialPosition;
  final Color dividerColor;
  final double dividerWidth;
  final Widget? beforeLabel;
  final Widget? afterLabel;
  final bool showLabels;

  const BeforeAfterSlider({
    Key? key,
    required this.beforeImagePath,
    required this.afterImagePath,
    this.initialPosition = 0.5,
    this.dividerColor = Colors.white,
    this.dividerWidth = 2.0,
    this.beforeLabel,
    this.afterLabel,
    this.showLabels = true,
  }) : super(key: key);

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();

  @override
  Element createElement() => _BeforeAfterSliderElement(this);
}

class _BeforeAfterSliderElement extends ComponentElement {
  _BeforeAfterSliderElement(BeforeAfterSlider widget) : super(widget);

  @override
  BeforeAfterSlider get widget => super.widget as BeforeAfterSlider;

  @override
  Widget build() {
    return _BeforeAfterSliderWidget(
      beforeImagePath: widget.beforeImagePath,
      afterImagePath: widget.afterImagePath,
      initialPosition: widget.initialPosition,
      dividerColor: widget.dividerColor,
      dividerWidth: widget.dividerWidth,
      beforeLabel: widget.beforeLabel,
      afterLabel: widget.afterLabel,
      showLabels: widget.showLabels,
    );
  }
}

class _BeforeAfterSliderWidget extends StatefulWidget {
  final String beforeImagePath;
  final String afterImagePath;
  final double initialPosition;
  final Color dividerColor;
  final double dividerWidth;
  final Widget? beforeLabel;
  final Widget? afterLabel;
  final bool showLabels;

  const _BeforeAfterSliderWidget({
    required this.beforeImagePath,
    required this.afterImagePath,
    this.initialPosition = 0.5,
    this.dividerColor = Colors.white,
    this.dividerWidth = 2.0,
    this.beforeLabel,
    this.afterLabel,
    this.showLabels = true,
  });

  @override
  State<_BeforeAfterSliderWidget> createState() => _BeforeAfterSliderWidgetState();
}

class _BeforeAfterSliderWidgetState extends State<_BeforeAfterSliderWidget> {
  late double _sliderPosition;

  @override
  void initState() {
    super.initState();
    _sliderPosition = widget.initialPosition.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _sliderPosition = (details.localPosition.dx / width).clamp(0.0, 1.0);
            });
          },
          onTapDown: (details) {
            setState(() {
              _sliderPosition = (details.localPosition.dx / width).clamp(0.0, 1.0);
            });
          },
          child: Stack(
            children: [
              // After image (full width)
              Positioned.fill(
                child: Image.file(
                  File(widget.afterImagePath),
                  fit: BoxFit.cover,
                ),
              ),

              // Before image (clipped)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: width * _sliderPosition,
                child: ClipRect(
                  child: Image.file(
                    File(widget.beforeImagePath),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),

              // Divider line
              Positioned(
                left: width * _sliderPosition - widget.dividerWidth / 2,
                top: 0,
                bottom: 0,
                child: Container(
                  width: widget.dividerWidth,
                  color: widget.dividerColor,
                ),
              ),

              // Slider handle
              Positioned(
                left: width * _sliderPosition - 20,
                top: constraints.maxHeight / 2 - 20,
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
                  child: Icon(
                    Icons.drag_handle,
                    color: widget.dividerColor == Colors.white
                        ? Colors.black
                        : Colors.white,
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
                          'BEFORE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
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
                          'AFTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
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

/// Alternative vertical before/after slider
class VerticalBeforeAfterSlider extends StatefulWidget {
  final String beforeImagePath;
  final String afterImagePath;
  final double initialPosition;
  final Color dividerColor;
  final double dividerWidth;

  const VerticalBeforeAfterSlider({
    Key? key,
    required this.beforeImagePath,
    required this.afterImagePath,
    this.initialPosition = 0.5,
    this.dividerColor = Colors.white,
    this.dividerWidth = 2.0,
  }) : super(key: key);

  @override
  State<VerticalBeforeAfterSlider> createState() => _VerticalBeforeAfterSliderState();
}

class _VerticalBeforeAfterSliderState extends State<VerticalBeforeAfterSlider> {
  late double _sliderPosition;

  @override
  void initState() {
    super.initState();
    _sliderPosition = widget.initialPosition.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        return GestureDetector(
          onVerticalDragUpdate: (details) {
            setState(() {
              _sliderPosition = (details.localPosition.dy / height).clamp(0.0, 1.0);
            });
          },
          onTapDown: (details) {
            setState(() {
              _sliderPosition = (details.localPosition.dy / height).clamp(0.0, 1.0);
            });
          },
          child: Stack(
            children: [
              // After image (full height)
              Positioned.fill(
                child: Image.file(
                  File(widget.afterImagePath),
                  fit: BoxFit.cover,
                ),
              ),

              // Before image (clipped)
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: height * _sliderPosition,
                child: ClipRect(
                  child: Image.file(
                    File(widget.beforeImagePath),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),

              // Divider line
              Positioned(
                left: 0,
                right: 0,
                top: height * _sliderPosition - widget.dividerWidth / 2,
                child: Container(
                  height: widget.dividerWidth,
                  color: widget.dividerColor,
                ),
              ),

              // Slider handle
              Positioned(
                left: constraints.maxWidth / 2 - 20,
                top: height * _sliderPosition - 20,
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
                  child: Icon(
                    Icons.drag_handle,
                    color: widget.dividerColor == Colors.white
                        ? Colors.black
                        : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
