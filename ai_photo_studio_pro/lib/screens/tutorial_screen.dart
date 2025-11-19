import 'package:flutter/material.dart';
import '../services/tutorial_service.dart';

/// Interactive tutorial screen for onboarding
class TutorialScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const TutorialScreen({
    Key? key,
    this.onComplete,
  }) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final _tutorialService = TutorialService();
  final _pageController = PageController();

  late List<TutorialStep> _steps;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _steps = _tutorialService.getMainTutorialSteps();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text('Skip'),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return _buildTutorialPage(_steps[index]);
                },
              ),
            ),

            // Page indicator
            _buildPageIndicator(),
            const SizedBox(height: 24),

            // Navigation buttons
            _buildNavigationButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage(TutorialStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              step.icon,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            step.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Action button (if any)
          if (step.action != null)
            OutlinedButton.icon(
              onPressed: () => _handleAction(step.action!),
              icon: const Icon(Icons.arrow_forward),
              label: Text(_getActionLabel(step.action!)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _steps.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == _steps.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (_currentPage > 0)
            TextButton(
              onPressed: _previousPage,
              child: const Text('Back'),
            )
          else
            const SizedBox(width: 80),

          // Next/Done button
          ElevatedButton(
            onPressed: isLastPage ? _complete : _nextPage,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isLastPage ? 'Get Started' : 'Next',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _skip() async {
    await _tutorialService.markTutorialCompleted();
    widget.onComplete?.call();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _complete() async {
    await _tutorialService.markTutorialCompleted();
    widget.onComplete?.call();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleAction(TutorialAction action) {
    // Handle tutorial actions - show informative messages
    switch (action) {
      case TutorialAction.openCamera:
        // In tutorial mode, just show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera will open when you complete the tutorial 📸'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case TutorialAction.openStyles:
        // In tutorial mode, just show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Styles will be available after tutorial 🎨'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case TutorialAction.openGallery:
        // In tutorial mode, just show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery will be available after tutorial 🖼️'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case TutorialAction.openPremium:
        // In tutorial mode, just show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Premium features available after tutorial ⭐'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  String _getActionLabel(TutorialAction action) {
    switch (action) {
      case TutorialAction.openCamera:
        return 'Try Camera';
      case TutorialAction.openStyles:
        return 'Browse Styles';
      case TutorialAction.openGallery:
        return 'View Gallery';
      case TutorialAction.openPremium:
        return 'See Premium';
    }
  }
}
