import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_state.dart';
import '../providers/theme_provider_v2.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import 'common/app_spacer.dart';

class ModernDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const ModernDrawer({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userState = context.watch<UserState>();
    final themeProviderV2 = context.watch<ThemeProviderV2>();

    return Container(
      decoration: BoxDecoration(color: context.colors.background),
      child: SafeArea(
        child: Column(
          children: [
            // Header with user info
            _buildHeader(context, userState, l10n, themeProviderV2),

            AppSpacer.v8(),

            // Menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space12,
                ),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.history,
                    title: l10n.scanHistory,
                    onTap: () {
                      onClose();
                      context.push('/history');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.chat_bubble_outline,
                    title: l10n.aiChats,
                    onTap: () {
                      onClose();
                      context.push('/dialogues');
                    },
                  ),
                  Divider(height: AppDimensions.space24),
                  _buildMenuItem(
                    context,
                    icon: Icons.cake_outlined,
                    title: l10n.age,
                    onTap: () {
                      onClose();
                      context.push('/age');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.face_outlined,
                    title: l10n.skinType,
                    onTap: () {
                      onClose();
                      context.push('/skintype');
                    },
                  ),
                  Divider(height: AppDimensions.space24),
                  _buildMenuItem(
                    context,
                    icon: Icons.palette_outlined,
                    title: l10n.themes,
                    onTap: () {
                      onClose();
                      context.push('/theme-selection');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.language_outlined,
                    title: l10n.language,
                    onTap: () {
                      onClose();
                      context.push('/language');
                    },
                  ),
                  Divider(height: AppDimensions.space24),
                  // Legal links in single column
                  _buildLegalLink(context, l10n.privacyPolicy, () {
                    onClose();
                    _launchURL(
                      'https://docs.google.com/document/d/1u7cY7Y0wYsvNpPTARFiPLIBgnaFtggNLtS4P1zfD544/edit?usp=sharing',
                    );
                  }),
                  AppSpacer.v8(),
                  _buildLegalLink(context, l10n.termsOfService, () {
                    onClose();
                    _launchURL(
                      'https://docs.google.com/document/d/1ubN7Enoihgx0Q37fmsQ6fg3sT_meMhEUVAHiEeyp540/edit?usp=sharing',
                    );
                  }),
                  AppSpacer.v16(),
                ],
              ),
            ),

            // Fixed Premium button at bottom (only for non-premium users)
            if (!userState.isPremium)
              Container(
                padding: EdgeInsets.all(AppDimensions.space16),
                child: _buildMenuItem(
                  context,
                  icon: Icons.workspace_premium_outlined,
                  title: l10n.goPremium,
                  gradient: context.colors.primaryGradient,
                  onTap: () {
                    onClose();
                    context.push('/modern-paywall');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    UserState userState,
    AppLocalizations l10n,
    ThemeProviderV2 themeProviderV2,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        gradient: context.colors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radius24),
          bottomRight: Radius.circular(AppDimensions.radius24),
        ),
        boxShadow: [AppTheme.getColoredShadow(context.colors.onSecondary)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row with theme toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar + Name
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onClose();
                    context.push('/profile');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: AppDimensions.avatarMedium,
                        height: AppDimensions.avatarMedium,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: AppDimensions.space8,
                              offset: const Offset(0, AppDimensions.space4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: userState.photoBase64 != null
                              ? Image.memory(
                                  base64Decode(userState.photoBase64!),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  child: Icon(
                                    Icons.person,
                                    size: AppDimensions.iconLarge,
                                    color: context.colors.primary,
                                  ),
                                ),
                        ),
                      ),
                      AppSpacer.h16(),
                      // Name с автоматическим масштабированием
                      Expanded(
                        child: Text(
                          (userState.name != null && userState.name!.isNotEmpty)
                              ? userState.name!
                              : l10n.userName,
                          style: TextStyle(
                            color: context.colors.isDark
                                ? const Color(
                                    0xFF1A1A1A,
                                  ) // Very dark gray for dark theme
                                : Colors.white, // White for light theme
                            fontSize: AppDimensions.space16,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTheme.fontFamilySerif,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Theme toggle button
              IconButton(
                onPressed: () {
                  themeProviderV2.toggleTheme();
                },
                icon: Icon(
                  themeProviderV2.isDarkTheme
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: context.colors.isDark
                      ? const Color(0xFF1A1A1A) // Very dark gray for dark theme
                      : Colors.white, // White for light theme
                  size: AppDimensions.iconMedium,
                ),
              ),
            ],
          ),
          AppSpacer.v16(),
          // Status badge (subscription)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space12,
              vertical: AppDimensions.space8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  userState.isPremium ? Icons.star : Icons.star_border,
                  color: context.colors.isDark
                      ? const Color(0xFF1A1A1A) // Very dark gray for dark theme
                      : Colors.white, // White for light theme
                  size: AppDimensions.iconSmall,
                ),
                AppSpacer.h8(),
                // Масштабирование текста если не вмещается
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userState.isPremium ? l10n.premiumUser : l10n.freeUser,
                      style: TextStyle(
                        color: context.colors.isDark
                            ? const Color(
                                0xFF1A1A1A,
                              ) // Very dark gray for dark theme
                            : Colors.white, // White for light theme
                        fontSize: AppDimensions.space16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Gradient? gradient,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.space4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Material(
        color: gradient != null ? Colors.transparent : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: gradient != null
                      ? (context.colors.isDark
                            ? const Color(
                                0xFF1A1A1A,
                              ) // Very dark gray for dark theme
                            : Colors.white)
                      : context.colors.onBackground,
                  size: AppDimensions.iconMedium,
                ),
                AppSpacer.h16(),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: gradient != null
                          ? (context.colors.isDark
                                ? const Color(
                                    0xFF1A1A1A,
                                  ) // Very dark gray for dark theme
                                : Colors.white)
                          : context.colors.onBackground,
                      fontSize: AppDimensions.iconSmall,
                      fontWeight: gradient != null
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.clip,
                    maxLines: null,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: gradient != null
                      ? (context.colors.isDark
                            ? const Color(0xFF1A1A1A).withValues(
                                alpha: 0.7,
                              ) // Very dark gray with transparency
                            : Colors.white.withValues(alpha: 0.7))
                      : context.colors.onSecondary,
                  size: AppDimensions.iconMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegalLink(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: context.colors.onSecondary,
                  fontSize: AppDimensions.space12,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
