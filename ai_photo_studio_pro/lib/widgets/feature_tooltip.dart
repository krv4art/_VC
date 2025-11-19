import 'package:flutter/material.dart';
import '../services/tutorial_service.dart';

/// Widget to show feature tooltips
class FeatureTooltipOverlay extends StatefulWidget {
  final String featureId;
  final String title;
  final String message;
  final Widget child;
  final TooltipPosition position;

  const FeatureTooltipOverlay({
    Key? key,
    required this.featureId,
    required this.title,
    required this.message,
    required this.child,
    this.position = TooltipPosition.bottom,
  }) : super(key: key);

  @override
  State<FeatureTooltipOverlay> createState() => _FeatureTooltipOverlayState();
}

class _FeatureTooltipOverlayState extends State<FeatureTooltipOverlay> {
  final _tutorialService = TutorialService();
  bool _shouldShow = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _checkShouldShow();
  }

  Future<void> _checkShouldShow() async {
    final shown = await _tutorialService.isFeatureTooltipShown(widget.featureId);
    if (!shown && mounted) {
      setState(() => _shouldShow = true);
      // Show after a small delay
      Future.delayed(const Duration(milliseconds: 500), _showTooltip);
    }
  }

  void _showTooltip() {
    if (!_shouldShow || !mounted) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipContent(
        title: widget.title,
        message: widget.message,
        targetRect: Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
        position: widget.position,
        onDismiss: _dismissTooltip,
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  Future<void> _dismissTooltip() async {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _shouldShow = false);
    await _tutorialService.markFeatureTooltipShown(widget.featureId);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _TooltipContent extends StatelessWidget {
  final String title;
  final String message;
  final Rect targetRect;
  final TooltipPosition position;
  final VoidCallback onDismiss;

  const _TooltipContent({
    required this.title,
    required this.message,
    required this.targetRect,
    required this.position,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: onDismiss,
        child: Stack(
          children: [
            // Highlight target
            Positioned(
              left: targetRect.left - 8,
              top: targetRect.top - 8,
              child: Container(
                width: targetRect.width + 16,
                height: targetRect.height + 16,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Tooltip card
            Positioned(
              left: _getLeft(context),
              top: _getTop(),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: onDismiss,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: onDismiss,
                        child: const Text('Got it!'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getLeft(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tooltipWidth = 300.0;

    switch (position) {
      case TooltipPosition.left:
        return targetRect.left - tooltipWidth - 24;
      case TooltipPosition.right:
        return targetRect.right + 8;
      case TooltipPosition.top:
      case TooltipPosition.bottom:
        final centered = targetRect.center.dx - tooltipWidth / 2;
        if (centered < 16) return 16;
        if (centered + tooltipWidth > screenWidth - 16) {
          return screenWidth - tooltipWidth - 16;
        }
        return centered;
    }
  }

  double _getTop() {
    switch (position) {
      case TooltipPosition.top:
        return targetRect.top - 200; // Approximate tooltip height
      case TooltipPosition.bottom:
        return targetRect.bottom + 8;
      case TooltipPosition.left:
      case TooltipPosition.right:
        return targetRect.top;
    }
  }
}

enum TooltipPosition {
  top,
  bottom,
  left,
  right,
}
