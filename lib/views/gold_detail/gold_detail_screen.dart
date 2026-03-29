import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../data/models/gold_item.dart';
import '../../viewmodels/gold_list_viewmodel.dart';
import '../../viewmodels/zakat_viewmodel.dart';

class GoldDetailScreen extends ConsumerWidget {
  final GoldItem item;

  const GoldDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final karatColor = AppColors.karatColors[item.karat] ?? AppColors.gold;
    final priceAsync = ref.watch(goldPriceProvider);
    final pricePerGram = priceAsync.valueOrNull ?? 320.0;
    final approxValue = pricePerGram *
        item.weight *
        (item.karat / 24.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.editGold, extra: item),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _confirmDelete(context, ref, l10n),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image
            _buildImage(item),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Karat badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: karatColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: karatColor),
                      ),
                      child: Text(
                        '${item.karat} ${l10n.karat}',
                        style: TextStyle(
                          color: karatColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Details grid
                  _buildDetailsCard(context, l10n, karatColor, approxValue),
                  const SizedBox(height: 16),

                  // Notes
                  if (item.notes != null && item.notes!.isNotEmpty)
                    _buildNotesCard(context, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(GoldItem item) {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return Image.file(
        File(item.imagePath!),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildNoImage(),
      );
    }
    return _buildNoImage();
  }

  Widget _buildNoImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: AppColors.darkCard,
      child: const Center(
        child: Text('🏅', style: TextStyle(fontSize: 80)),
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context,
    AppLocalizations l10n,
    Color karatColor,
    double approxValue,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(context, Icons.scale, l10n.weight,
                '${item.weight} ${l10n.gram}', karatColor),
            Divider(color: theme.dividerColor),
            _buildDetailRow(context, Icons.attach_money, l10n.purchasePrice,
                '${item.purchasePrice.toStringAsFixed(0)} ${l10n.currency}',
                karatColor),
            Divider(color: theme.dividerColor),
            _buildDetailRow(
              context,
              Icons.trending_up,
              l10n.totalValue,
              '${approxValue.toStringAsFixed(0)} ${l10n.currency}',
              AppColors.success,
            ),
            Divider(color: theme.dividerColor),
            _buildDetailRow(
              context,
              Icons.calendar_today,
              l10n.purchaseDate,
              DateFormat('dd MMM yyyy').format(item.purchaseDate),
              karatColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notes, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                Text(l10n.notes,
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Text(item.notes!, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(goldListProvider.notifier).deleteItem(item.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.goldDeleted)),
                );
                context.pop();
              }
            },
            child: Text(l10n.delete,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
