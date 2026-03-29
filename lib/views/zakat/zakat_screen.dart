import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/zakat_viewmodel.dart';

class ZakatScreen extends ConsumerWidget {
  const ZakatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final zakatInfo = ref.watch(zakatInfoProvider);
    final priceAsync = ref.watch(goldPriceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.zakat)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nisaab Status
            _buildNisaabCard(context, l10n, zakatInfo),
            const SizedBox(height: 16),

            // Gold Price Card
            _buildPriceCard(context, l10n, ref, priceAsync),
            const SizedBox(height: 16),

            // Stats
            _buildStatsGrid(context, l10n, zakatInfo),
            const SizedBox(height: 16),

            // Zakat Result
            if (zakatInfo.hasReachedNisaab)
              _buildZakatResult(context, l10n, zakatInfo),

            // Explanation
            const SizedBox(height: 16),
            _buildExplanation(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildNisaabCard(
    BuildContext context,
    AppLocalizations l10n,
    ZakatInfo zakatInfo,
  ) {
    final color =
        zakatInfo.hasReachedNisaab ? AppColors.success : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            zakatInfo.hasReachedNisaab
                ? l10n.reachedNisaab
                : l10n.notReachedNisaab,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.nisaabInfo,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 13),
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (zakatInfo.totalWeight24K / 85.0).clamp(0.0, 1.0),
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${zakatInfo.totalWeight24K.toStringAsFixed(1)} / 85 ${l10n.gram}',
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    AsyncValue<double> priceAsync,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, color: AppColors.gold),
                const SizedBox(width: 8),
                Text(l10n.currentGoldPrice,
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            priceAsync.when(
              data: (price) => Text(
                '$price ${l10n.currency} / ${l10n.gram}',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('--'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ref
                        .read(goldPriceProvider.notifier)
                        .fetchFromApi(),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(l10n.updatePrice),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showPriceDialog(context, l10n, ref),
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(l10n.enterPriceManually),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AppLocalizations l10n,
    ZakatInfo zakatInfo,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            label: l10n.totalWeight,
            value:
                '${zakatInfo.totalWeightGrams.toStringAsFixed(2)} ${l10n.gram}',
            icon: Icons.scale,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            label: l10n.totalValue,
            value:
                '${zakatInfo.totalValue.toStringAsFixed(0)} ${l10n.currency}',
            icon: Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.gold, size: 22),
            const SizedBox(height: 8),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZakatResult(
    BuildContext context,
    AppLocalizations l10n,
    ZakatInfo zakatInfo,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldDark, AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            '🕌',
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.zakatDue,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${zakatInfo.zakatAmount.toStringAsFixed(2)} ${l10n.currency}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.zakatRate,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanation(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.zakatExplanation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceDialog(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.enterGoldPrice),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.priceNote, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.goldPricePerGram,
                suffixText: l10n.currency,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(controller.text);
              if (price != null && price > 0) {
                ref.read(goldPriceProvider.notifier).setPrice(price);
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
