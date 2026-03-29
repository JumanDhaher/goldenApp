import 'dart:io';
import 'package:flutter/material.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/gold_placeholder.dart';
import '../../../data/models/gold_item.dart';

class GoldCard extends StatelessWidget {
  final GoldItem item;
  final double goldPrice24;
  final VoidCallback onTap;

  const GoldCard({
    super.key,
    required this.item,
    required this.goldPrice24,
    required this.onTap,
  });

  String _getTypeIcon() {
    switch (item.type) {
      case 'ring':     return '💍';
      case 'bar':      return '🏅';
      case 'necklace': return '📿';
      default:         return '✨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n       = AppLocalizations.of(context)!;
    final karatColor = AppColors.karatColors[item.karat] ?? AppColors.gold;
    final theme      = Theme.of(context);
    final isDark     = theme.brightness == Brightness.dark;

    // القيمة الحالية بسعر السوق
    final currentValue = item.weight * (item.karat / 24.0) * goldPrice24;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightSurface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: karatColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // صورة أو أيقونة
              _buildImage(karatColor),
              const SizedBox(width: 14),

              // معلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم + العيار
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: karatColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${item.karat}K',
                            style: TextStyle(
                              color: karatColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // الوزن + النوع
                    Row(
                      children: [
                        Text(
                          '${item.weight} ${l10n.gram}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getTypeIcon(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // القيمة الحالية بسعر السوق
                    Row(
                      children: [
                        Text(
                          '${currentValue.toStringAsFixed(0)} ${l10n.currency}',
                          style: TextStyle(
                            color: karatColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDark
                              ? '· ${l10n.totalValue}'
                              : '· ${l10n.totalValue}',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(Color karatColor) {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(item.imagePath!),
          width: 58,
          height: 58,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildIconBox(karatColor),
        ),
      );
    }
    return _buildIconBox(karatColor);
  }

  Widget _buildIconBox(Color karatColor) {
    return GoldPlaceholder(
      size: GoldPlaceholderSize.small,
      accentColor: karatColor,
    );
  }
}
