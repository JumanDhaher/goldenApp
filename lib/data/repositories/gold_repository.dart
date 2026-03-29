import 'package:hive/hive.dart';
import '../local/hive_service.dart';
import '../models/gold_item.dart';

class GoldRepository {
  Box<GoldItem> get _box => HiveService.goldBox;

  List<GoldItem> getAll() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  GoldItem? getById(String id) {
    try {
      return _box.values.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> add(GoldItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> update(GoldItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> delete(String id) async {
    final item = getById(id);
    if (item != null) {
      await item.delete();
    }
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  Stream<BoxEvent> watch() => _box.watch();
}
