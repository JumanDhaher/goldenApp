import 'dart:io';
import 'package:flutter/material.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/gold_item.dart';

class GoldCard extends StatelessWidget {
  final GoldItem item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const GoldCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
  });

  String _getTypeIcon() {
    switch (item.type) {
      case 'ring':
        return '💍';
      case 'bar':
        return '🏅';
      case 'necklace':
        return '📿';
      default:
        return '✨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final karatColor =
        AppColors.karatColors[item.karat] ?? AppColors.gold;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: karatColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image or icon
              _buildImage(karatColor),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: karatColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${item.karat}K',
                            style: TextStyle(
                              color: karatColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${item.weight} ${l10n.grams}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _getTypeIcon(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (item.purchasePrice > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${item.purchasePrice.toStringAsFixed(0)} ${l10n.currency}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: karatColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(Color karatColor) {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(item.imagePath!),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildIconBox(karatColor),
        ),
      );
    }
    return _buildIconBox(karatColor);
  }

  Widget _buildIconBox(Color karatColor) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: karatColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: karatColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          _getTypeIcon(),
          style: const TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}
