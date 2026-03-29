import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../viewmodels/gold_list_viewmodel.dart';
import '../../viewmodels/zakat_viewmodel.dart';
import 'widgets/gold_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final goldItems = ref.watch(goldListProvider);
    final zakatInfo = ref.watch(zakatInfoProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✦ '),
            Text(l10n.appName),
            const Text(' ✦'),
          ],
        ),
      ),
      body: goldItems.isEmpty
          ? _buildEmptyState(context, l10n)
          : CustomScrollView(
              slivers: [
                // Summary card
                SliverToBoxAdapter(
                  child: _buildSummaryCard(context, l10n, zakatInfo, theme),
                ),
                // List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = goldItems[index];
                        return GoldCard(
                          item: item,
                          onTap: () => context.push(
                            AppRoutes.goldDetail,
                            extra: item,
                          ),
                        );
                      },
                      childCount: goldItems.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addGold),
        icon: const Icon(Icons.add),
        label: Text(l10n.addGold),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    AppLocalizations l10n,
    dynamic zakatInfo,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldDark, AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalGold,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${zakatInfo.totalWeightGrams.toStringAsFixed(2)} ${l10n.gram}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryItem(
                l10n.totalValue,
                '${zakatInfo.totalValue.toStringAsFixed(0)} ${l10n.currency}',
              ),
              const SizedBox(width: 24),
              _buildSummaryItem(
                l10n.zakatAmount,
                zakatInfo.hasReachedNisaab
                    ? '${zakatInfo.zakatAmount.toStringAsFixed(0)} ${l10n.currency}'
                    : l10n.noZakatDue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🏅',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noGoldYet,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.addFirstGold,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
