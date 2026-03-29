import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/gold_item.dart';
import '../data/repositories/gold_repository.dart';

final goldRepositoryProvider = Provider<GoldRepository>((ref) {
  return GoldRepository();
});

final goldListProvider =
    StateNotifierProvider<GoldListNotifier, List<GoldItem>>((ref) {
  final repo = ref.watch(goldRepositoryProvider);
  return GoldListNotifier(repo);
});

class GoldListNotifier extends StateNotifier<List<GoldItem>> {
  final GoldRepository _repository;

  GoldListNotifier(this._repository) : super([]) {
    _loadItems();
    _repository.watch().listen((_) => _loadItems());
  }

  void _loadItems() {
    state = _repository.getAll();
  }

  Future<void> addItem(GoldItem item) async {
    await _repository.add(item);
    _loadItems();
  }

  Future<void> updateItem(GoldItem item) async {
    await _repository.update(item);
    _loadItems();
  }

  Future<void> deleteItem(String id) async {
    await _repository.delete(id);
    _loadItems();
  }

  void refresh() => _loadItems();
}
