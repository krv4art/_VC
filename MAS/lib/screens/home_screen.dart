import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_spacer.dart';
import '../services/rating_service.dart';
import '../widgets/rating_request_dialog.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkRatingDialog();
  }

  /// Проверка и показ диалога оценки
  Future<void> _checkRatingDialog() async {
    // Небольшая задержка, чтобы экран успел отрисоваться
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final shouldShow = await RatingService().shouldShowRatingDialog();
    if (shouldShow && mounted) {
      await RatingService().incrementRatingDialogShows();
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RatingRequestDialog(),
        );
      }
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for 5 mode cards
    _fadeAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end > 1.0 ? 1.0 : end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      final end = start + 0.4;
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end > 1.0 ? 1.0 : end, curve: Curves.easeOut),
        ),
      );
    });

    // Start animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
            tooltip: l10n.history,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                l10n.chooseMode,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.mathAiAssistant,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),

              // Mode cards
              _buildAnimatedModeCard(
                index: 0,
                title: l10n.solve,
                subtitle: l10n.solveWithAI,
                icon: Icons.lightbulb_outline,
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                onTap: () => context.push('/solve'),
              ),
              AppSpacer.v16(),

              _buildAnimatedModeCard(
                index: 1,
                title: l10n.check,
                subtitle: l10n.checkSolution,
                icon: Icons.check_circle_outline,
                gradient: const LinearGradient(
                  colors: [Color(0xFF48BB78), Color(0xFF38A169)],
                ),
                onTap: () => context.push('/check'),
              ),
              AppSpacer.v16(),

              _buildAnimatedModeCard(
                index: 2,
                title: l10n.train,
                subtitle: l10n.trainOnProblems,
                icon: Icons.fitness_center,
                gradient: const LinearGradient(
                  colors: [Color(0xFFED8936), Color(0xFFDD6B20)],
                ),
                onTap: () => context.push('/training'),
              ),
              AppSpacer.v16(),

              _buildAnimatedModeCard(
                index: 3,
                title: l10n.unitConverter,
                subtitle: l10n.unitConverterDesc,
                icon: Icons.straighten,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4299E1), Color(0xFF3182CE)],
                ),
                onTap: () => context.push('/converter'),
              ),
              AppSpacer.v16(),

              _buildAnimatedModeCard(
                index: 4,
                title: l10n.mathChat,
                subtitle: l10n.askQuestions,
                icon: Icons.chat_bubble_outline,
                gradient: const LinearGradient(
                  colors: [Color(0xFF9F7AEA), Color(0xFF805AD5)],
                ),
                onTap: () => context.push('/chat'),
              ),
              AppSpacer.v32(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedModeCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimations[index],
          child: SlideTransition(
            position: _slideAnimations[index],
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: AppTheme.headingMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
