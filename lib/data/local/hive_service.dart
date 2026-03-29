import 'package:hive_flutter/hive_flutter.dart';
import '../models/gold_item.dart';

class HiveService {
  static const String _goldBoxName = 'gold_items';
  static Box<GoldItem>? _goldBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GoldItemAdapter());
    }
    _goldBox = await Hive.openBox<GoldItem>(_goldBoxName);
  }

  static Box<GoldItem> get goldBox {
    if (_goldBox == null || !_goldBox!.isOpen) {
      throw Exception('Hive box not initialized. Call HiveService.init() first.');
    }
    return _goldBox!;
  }

  static Future<void> close() async {
    await _goldBox?.close();
  }
}
