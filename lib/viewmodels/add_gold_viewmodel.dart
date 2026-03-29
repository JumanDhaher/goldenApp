import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/gold_item.dart';
import 'gold_list_viewmodel.dart';

class AddGoldState {
  final String name;
  final String type;
  final int karat;
  final String weight;
  final String purchasePrice;
  final DateTime purchaseDate;
  final String? imagePath;
  final String notes;
  final bool isLoading;
  final bool isSaved;

  AddGoldState({
    this.name = '',
    this.type = 'ring',
    this.karat = 21,
    this.weight = '',
    this.purchasePrice = '',
    DateTime? purchaseDate,
    this.imagePath,
    this.notes = '',
    this.isLoading = false,
    this.isSaved = false,
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  AddGoldState copyWith({
    String? name,
    String? type,
    int? karat,
    String? weight,
    String? purchasePrice,
    DateTime? purchaseDate,
    String? imagePath,
    bool clearImage = false,
    String? notes,
    bool? isLoading,
    bool? isSaved,
  }) {
    return AddGoldState(
      name: name ?? this.name,
      type: type ?? this.type,
      karat: karat ?? this.karat,
      weight: weight ?? this.weight,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

final addGoldProvider =
    StateNotifierProvider.autoDispose<AddGoldNotifier, AddGoldState>((ref) {
  return AddGoldNotifier(ref);
});

final editGoldProvider = StateNotifierProvider.autoDispose
    .family<AddGoldNotifier, AddGoldState, GoldItem>((ref, item) {
  return AddGoldNotifier(ref, existingItem: item);
});

class AddGoldNotifier extends StateNotifier<AddGoldState> {
  final Ref _ref;
  final GoldItem? existingItem;

  AddGoldNotifier(this._ref, {this.existingItem})
      : super(
          existingItem != null
              ? AddGoldState(
                  name: existingItem.name,
                  type: existingItem.type,
                  karat: existingItem.karat,
                  weight: existingItem.weight.toString(),
                  purchasePrice: existingItem.purchasePrice.toString(),
                  purchaseDate: existingItem.purchaseDate,
                  imagePath: existingItem.imagePath,
                  notes: existingItem.notes ?? '',
                )
              : AddGoldState(purchaseDate: DateTime.now()),
        );

  void setName(String v) => state = state.copyWith(name: v);
  void setType(String v) => state = state.copyWith(type: v);
  void setKarat(int v) => state = state.copyWith(karat: v);
  void setWeight(String v) => state = state.copyWith(weight: v);
  void setPurchasePrice(String v) => state = state.copyWith(purchasePrice: v);
  void setPurchaseDate(DateTime v) => state = state.copyWith(purchaseDate: v);
  void setImagePath(String? v) => state = state.copyWith(imagePath: v);
  void setNotes(String v) => state = state.copyWith(notes: v);

  bool validate() {
    return state.name.isNotEmpty &&
        double.tryParse(state.weight) != null &&
        double.tryParse(state.purchasePrice) != null;
  }

  Future<bool> save() async {
    if (!validate()) return false;
    state = state.copyWith(isLoading: true);
    try {
      final item = GoldItem(
        id: existingItem?.id ?? const Uuid().v4(),
        name: state.name,
        type: state.type,
        karat: state.karat,
        weight: double.parse(state.weight),
        purchasePrice: double.parse(state.purchasePrice),
        purchaseDate: state.purchaseDate,
        imagePath: state.imagePath,
        notes: state.notes.isEmpty ? null : state.notes,
        createdAt: existingItem?.createdAt,
      );
      final goldList = _ref.read(goldListProvider.notifier);
      if (existingItem != null) {
        await goldList.updateItem(item);
      } else {
        await goldList.addItem(item);
      }
      state = state.copyWith(isLoading: false, isSaved: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
