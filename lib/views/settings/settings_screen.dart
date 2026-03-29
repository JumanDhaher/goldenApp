import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language
          _buildSectionTitle(context, l10n.language),
          _buildLanguageCard(context, l10n, ref, locale),
          const SizedBox(height: 16),

          // Theme
          _buildSectionTitle(context, l10n.theme),
          _buildThemeCard(context, l10n, ref, themeMode),
          const SizedBox(height: 16),

          // Premium
          _buildSectionTitle(context, l10n.premiumFeature),
          _buildPremiumCard(context, l10n, ref, isPremium),
          const SizedBox(height: 16),

          // App Info
          _buildAppInfo(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    Locale locale,
  ) {
    final isAr = locale.languageCode == 'ar';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _buildLangButton(
                context,
                label: l10n.arabic,
                isSelected: isAr,
                onTap: () => ref
                    .read(localeProvider.notifier)
                    .setLocale(const Locale('ar')),
              ),
            ),
            Expanded(
              child: _buildLangButton(
                context,
                label: l10n.english,
                isSelected: !isAr,
                onTap: () => ref
                    .read(localeProvider.notifier)
                    .setLocale(const Locale('en')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    ThemeMode themeMode,
  ) {
    final isDark = themeMode == ThemeMode.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _buildThemeButton(
                label: '🌑 ${l10n.dark}',
                isSelected: isDark,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setTheme(ThemeMode.dark),
              ),
            ),
            Expanded(
              child: _buildThemeButton(
                label: '☀️ ${l10n.light}',
                isSelected: !isDark,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setTheme(ThemeMode.light),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    bool isPremium,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  l10n.exportPdf,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✓ Active',
                      style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.premiumDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (!isPremium) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Integrate in-app purchase
                  ref.read(isPremiumProvider.notifier).unlock();
                },
                child: Text(l10n.unlockPremium),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('✦ Golden ✦',
                style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('v1.0.0',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              'Gold Tracking & Zakat App',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
