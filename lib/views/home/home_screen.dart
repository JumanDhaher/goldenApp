import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/pdf_export_service.dart';
import '../../viewmodels/gold_list_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../viewmodels/zakat_viewmodel.dart';
import 'widgets/gold_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n       = AppLocalizations.of(context)!;
    final goldItems  = ref.watch(goldListProvider);
    final zakatInfo  = ref.watch(zakatInfoProvider);
    final priceState = ref.watch(goldPriceProvider);
    final locale     = ref.watch(localeProvider);
    final isAr       = locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text('✦ ${l10n.appName} ✦'),
        actions: [
          if (goldItems.isNotEmpty)
            IconButton(
              tooltip: l10n.exportPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () => _exportPdf(context, ref, isAr),
            ),
        ],
      ),
      body: goldItems.isEmpty
          ? _buildEmptyState(context, l10n)
          : CustomScrollView(
              slivers: [
                // ── شريط أسعار العيارات (نفس الموقع) ──
                SliverToBoxAdapter(
                  child: _buildGoldPriceBar(
                      context, l10n, priceState, ref, isAr),
                ),
                // ── بطاقة الملخص ──
                SliverToBoxAdapter(
                  child: _buildSummaryCard(
                      context, l10n, zakatInfo, priceState, isAr),
                ),
                // ── قائمة الذهب ──
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = goldItems[index];
                        return GoldCard(
                          item: item,
                          goldPrice24: priceState.price,
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
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addGold),
        icon: const Icon(Icons.add),
        label: Text(l10n.addGold),
      ),
    );
  }

  // ── شريط أسعار العيارات الحية ────────────────────────────
  Widget _buildGoldPriceBar(
    BuildContext context,
    AppLocalizations l10n,
    GoldPriceState priceState,
    WidgetRef ref,
    bool isAr,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barBg  = isDark
        ? AppColors.darkSurface2
        : AppColors.gold.withOpacity(0.08);
    final textColor  = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final valueColor = isDark ? AppColors.goldLight : AppColors.lightGold;

    return Container(
      color: barBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [18, 21, 22, 24].map((k) {
                  final kPrice = priceState.karatPrice(k);
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${isAr ? 'عيار' : 'K'} $k',
                          style: TextStyle(fontSize: 10, color: textColor),
                        ),
                        Text(
                          '${kPrice.toStringAsFixed(1)} ${isAr ? 'ريال' : 'SAR'}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: valueColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // زر تحديث + وقت آخر تحديث
          GestureDetector(
            onTap: () => ref.read(goldPriceProvider.notifier).fetchFromApi(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                priceState.isLoading
                    ? const SizedBox(
                        width: 14, height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 1.5, color: AppColors.gold),
                      )
                    : Icon(Icons.refresh, size: 16, color: textColor),
                if (priceState.lastUpdated != null)
                  Text(
                    priceState.lastUpdated!,
                    style: TextStyle(fontSize: 9, color: textColor),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── بطاقة الملخص ─────────────────────────────────────────
  Widget _buildSummaryCard(
    BuildContext context,
    AppLocalizations l10n,
    ZakatInfo zakatInfo,
    GoldPriceState priceState,
    bool isAr,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldDark, AppColors.gold, AppColors.goldLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalGold,
            style: const TextStyle(
                color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            '${zakatInfo.totalWeightGrams.toStringAsFixed(2)} ${l10n.gram}',
            style: const TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  l10n.totalValue,
                  '${zakatInfo.totalValue.toStringAsFixed(0)} ${l10n.currency}',
                ),
              ),
              Container(width: 1, height: 36, color: Colors.black26),
              Expanded(
                child: _summaryItem(
                  l10n.zakatAmount,
                  zakatInfo.hasReachedNisaab
                      ? '${zakatInfo.zakatAmount.toStringAsFixed(0)} ${l10n.currency}'
                      : l10n.noZakatDue,
                  center: true,
                ),
              ),
              Container(width: 1, height: 36, color: Colors.black26),
              Expanded(
                child: _summaryItem(
                  isAr ? 'عيار 24 / جم' : '24K / g',
                  '${priceState.price.toStringAsFixed(1)} ${l10n.currency}',
                  end: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value,
      {bool center = false, bool end = false}) {
    final align = end
        ? CrossAxisAlignment.end
        : center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 10)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/gold_bars.png', width: 120, height: 120),
            const SizedBox(height: 24),
            Text(l10n.noGoldYet,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(l10n.addFirstGold,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ── تصدير PDF ─────────────────────────────────────────────
  Future<void> _exportPdf(
      BuildContext context, WidgetRef ref, bool isAr) async {
    final items      = ref.read(goldListProvider);
    final priceState = ref.read(goldPriceProvider);
    if (items.isEmpty) return;
    try {
      await PdfExportService.exportAndPrint(
        items: items,
        goldPrice24: priceState.price,
        isAr: isAr,
        context: context,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }
}
