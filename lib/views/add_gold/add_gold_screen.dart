import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/gold_item.dart';
import '../../viewmodels/add_gold_viewmodel.dart';

class AddGoldScreen extends ConsumerWidget {
  final GoldItem? existingItem;

  const AddGoldScreen({super.key, this.existingItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final provider = existingItem != null
        ? editGoldProvider(existingItem!)
        : addGoldProvider;

    final notifier = existingItem != null
        ? ref.read(editGoldProvider(existingItem!).notifier)
        : ref.read(addGoldProvider.notifier);

    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(existingItem != null ? l10n.editGold : l10n.addGold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image picker
            _buildImagePicker(context, l10n, state, notifier),
            const SizedBox(height: 20),

            // Name
            _buildTextField(
              context,
              label: l10n.itemName,
              hint: l10n.itemNameHint,
              initialValue: state.name,
              onChanged: notifier.setName,
            ),
            const SizedBox(height: 16),

            // Type selector
            _buildTypeSelector(context, l10n, state, notifier),
            const SizedBox(height: 16),

            // Karat selector
            _buildKaratSelector(context, l10n, state, notifier),
            const SizedBox(height: 16),

            // Weight
            _buildTextField(
              context,
              label: l10n.weight,
              initialValue: state.weight,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: notifier.setWeight,
            ),
            const SizedBox(height: 16),

            // Purchase Price
            _buildTextField(
              context,
              label: l10n.purchasePrice,
              initialValue: state.purchasePrice,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: notifier.setPurchasePrice,
            ),
            const SizedBox(height: 16),

            // Date
            _buildDatePicker(context, l10n, state, notifier),
            const SizedBox(height: 16),

            // Notes
            _buildTextField(
              context,
              label: l10n.notes,
              hint: l10n.notesHint,
              initialValue: state.notes,
              onChanged: notifier.setNotes,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final success = await notifier.save();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(existingItem != null
                                ? l10n.goldUpdated
                                : l10n.goldAdded),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        context.pop();
                      }
                    },
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.save),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(
    BuildContext context,
    AppLocalizations l10n,
    AddGoldState state,
    AddGoldNotifier notifier,
  ) {
    return GestureDetector(
      onTap: () => _showImageOptions(context, l10n, notifier),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gold.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: state.imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  File(state.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder(l10n),
                ),
              )
            : _imagePlaceholder(l10n),
      ),
    );
  }

  Widget _imagePlaceholder(AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add_a_photo_outlined,
            size: 40, color: AppColors.gold),
        const SizedBox(height: 8),
        Text(
          l10n.addPhoto,
          style: const TextStyle(color: AppColors.gold),
        ),
      ],
    );
  }

  void _showImageOptions(
    BuildContext context,
    AppLocalizations l10n,
    AddGoldNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.fromCamera),
              onTap: () async {
                Navigator.pop(ctx);
                final picker = ImagePicker();
                final xFile = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (xFile != null) notifier.setImagePath(xFile.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.fromGallery),
              onTap: () async {
                Navigator.pop(ctx);
                final picker = ImagePicker();
                final xFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (xFile != null) notifier.setImagePath(xFile.path);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(
    BuildContext context,
    AppLocalizations l10n,
    AddGoldState state,
    AddGoldNotifier notifier,
  ) {
    final types = [
      ('ring', '💍', l10n.ring),
      ('bar', '🏅', l10n.bar),
      ('necklace', '📿', l10n.necklace),
      ('other', '✨', l10n.other),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.type, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: types.map((t) {
            final isSelected = state.type == t.$1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => notifier.setType(t.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.gold.withOpacity(0.2)
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.gold
                            : AppColors.gold.withOpacity(0.2),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(t.$2, style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text(
                          t.$3,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? AppColors.gold : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKaratSelector(
    BuildContext context,
    AppLocalizations l10n,
    AddGoldState state,
    AddGoldNotifier notifier,
  ) {
    const karats = [18, 21, 22, 24];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.karat, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: karats.map((k) {
            final isSelected = state.karat == k;
            final karatColor = AppColors.karatColors[k] ?? AppColors.gold;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => notifier.setKarat(k),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? karatColor.withOpacity(0.2)
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? karatColor
                            : karatColor.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '$k',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? karatColor : null,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    AppLocalizations l10n,
    AddGoldState state,
    AddGoldNotifier notifier,
  ) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: state.purchaseDate,
          firstDate: DateTime(1980),
          lastDate: DateTime.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: Theme.of(ctx).colorScheme.copyWith(
                    primary: AppColors.gold,
                  ),
            ),
            child: child!,
          ),
        );
        if (date != null) notifier.setPurchaseDate(date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2E2E2E),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: AppColors.gold),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.purchaseDate,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM yyyy').format(state.purchaseDate),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    String? hint,
    required String initialValue,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
