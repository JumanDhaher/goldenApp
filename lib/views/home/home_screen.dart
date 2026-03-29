import 'dart:math' as math;

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
    final l10n = AppLocalizations.of(context);
    final goldItems = ref.watch(goldListProvider);
    final zakatInfo = ref.watch(zakatInfoProvider);
    final priceState = ref.watch(goldPriceProvider);
    final locale = ref.watch(localeProvider);
    final isAr = locale.languageCode == 'ar';

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
                SliverToBoxAdapter(child: _buildGoldPriceBar(context, l10n, priceState, ref, isAr)),
                // ── بطاقة الملخص ──
                SliverToBoxAdapter(child: _buildSummaryCard(context, l10n, zakatInfo, priceState, isAr)),
                // ── قائمة الذهب ──
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = goldItems[index];
                      return GoldCard(
                        item: item,
                        goldPrice24: priceState.price,
                        onTap: () => context.push(AppRoutes.goldDetail, extra: item),
                      );
                    }, childCount: goldItems.length),
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
    final barBg = isDark ? AppColors.darkSurface2 : AppColors.gold.withOpacity(0.08);
    final textColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
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
                        Text('${isAr ? 'عيار' : 'K'} $k', style: TextStyle(fontSize: 10, color: textColor)),
                        Text(
                          '${kPrice.toStringAsFixed(1)} ${isAr ? 'ريال' : 'SAR'}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: valueColor),
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
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
                      )
                    : Icon(Icons.refresh, size: 16, color: textColor),
                if (priceState.lastUpdated != null)
                  Text(priceState.lastUpdated!, style: TextStyle(fontSize: 9, color: textColor)),
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
        boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalGold,
            style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            '${zakatInfo.totalWeightGrams.toStringAsFixed(2)} ${l10n.gram}',
            style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _summaryItem(l10n.totalValue, '${zakatInfo.totalValue.toStringAsFixed(0)} ${l10n.currency}'),
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

  Widget _summaryItem(String label, String value, {bool center = false, bool end = false}) {
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
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated gold icon with rings
          _EmptyStateIcon(),
          const SizedBox(height: 32),
          // Title
          Text(
            l10n.noGoldYet,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l10n.addFirstGold,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkTextMuted, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          // Decorative divider
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dot(),
              const SizedBox(width: 8),
              Container(
                width: 60,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0), AppColors.gold.withOpacity(0.5)]),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withOpacity(0.6), width: 1.5),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 60,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.5), AppColors.gold.withOpacity(0)]),
                ),
              ),
              const SizedBox(width: 8),
              _dot(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dot() => Container(
    width: 4,
    height: 4,
    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.gold.withOpacity(0.4)),
  );

  // ── تصدير PDF ─────────────────────────────────────────────
  Future<void> _exportPdf(BuildContext context, WidgetRef ref, bool isAr) async {
    final items = ref.read(goldListProvider);
    final priceState = ref.read(goldPriceProvider);
    if (items.isEmpty) return;
    try {
      await PdfExportService.exportAndPrint(items: items, goldPrice24: priceState.price, isAr: isAr, context: context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }
}

// ─── Empty State Icon ────────────────────────────────────────────────────────
class _EmptyStateIcon extends StatefulWidget {
  @override
  State<_EmptyStateIcon> createState() => _EmptyStateIconState();
}

class _EmptyStateIconState extends State<_EmptyStateIcon> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _rotate = Tween<double>(begin: 0, end: 2 * math.pi).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating dashed ring
              Transform.rotate(
                angle: _rotate.value,
                child: CustomPaint(
                  size: const Size(170, 170),
                  painter: _DashedRingPainter(color: AppColors.gold.withOpacity(0.18), dashCount: 24),
                ),
              ),
              // Middle static ring
              CustomPaint(
                size: const Size(138, 138),
                painter: _SolidRingPainter(color: AppColors.gold.withOpacity(0.25), strokeWidth: 1),
              ),
              // Inner glow circle
              Transform.scale(
                scale: _pulse.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [AppColors.gold.withOpacity(0.15), AppColors.gold.withOpacity(0.04), Colors.transparent],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    border: Border.all(color: AppColors.gold.withOpacity(0.35), width: 1.5),
                  ),
                ),
              ),
              // Gold icon in center
              Image.asset('assets/images/gold_bars.png', width: 52, height: 52),
              //  CustomPaint(size: const Size(52, 52), painter: _GoldBarsPainter()),
              // 4 corner diamonds
              ..._cornerDots(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _cornerDots() {
    const r = 85.0;
    return [0, 1, 2, 3].map((i) {
      final angle = math.pi / 4 + i * math.pi / 2;
      return Positioned(
        left: 90 + r * math.cos(angle) - 4,
        top: 90 + r * math.sin(angle) - 4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gold.withOpacity(0.5),
            boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)],
          ),
        ),
      );
    }).toList();
  }
}

// ── Dashed ring ───────────────────────────────────────────────────────────────
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final int dashCount;
  const _DashedRingPainter({required this.color, required this.dashCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final r = size.width / 2;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final step = 2 * math.pi / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * step;
      final endAngle = startAngle + step * 0.45;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ── Solid ring ────────────────────────────────────────────────────────────────
class _SolidRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _SolidRingPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ── Gold bars icon (center) ───────────────────────────────────────────────────
class _GoldBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void drawBar(Rect r, {bool highlight = false}) {
      // shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(r.translate(1.5, 1.5), const Radius.circular(3)),
        Paint()..color = const Color(0x55000000),
      );
      // body gradient
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: highlight
              ? [const Color(0xFFF5DC80), const Color(0xFFC9A84C), const Color(0xFF8A6010)]
              : [const Color(0xFFE8C97A), const Color(0xFFC9A84C), const Color(0xFF9A7220)],
        ).createShader(r);
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), paint);
      // top shine
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(r.left + 4, r.top + 2, r.width - 8, 4), const Radius.circular(2)),
        Paint()..color = Colors.white.withOpacity(0.25),
      );
      // outline
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(3)),
        Paint()
          ..color = const Color(0xFFA07820).withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }

    // 3 staggered bars
    drawBar(Rect.fromLTWH(w * 0.18, h * 0.06, w * 0.64, h * 0.26));
    drawBar(Rect.fromLTWH(w * 0.06, h * 0.38, w * 0.56, h * 0.26), highlight: true);
    drawBar(Rect.fromLTWH(w * 0.28, h * 0.66, w * 0.60, h * 0.26));
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}
