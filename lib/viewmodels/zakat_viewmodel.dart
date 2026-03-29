import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/utils/gold_calculator.dart';
import '../data/models/gold_item.dart';
import 'gold_list_viewmodel.dart';

// Gold price provider (price per gram of 24K gold in SAR)
final goldPriceProvider =
    StateNotifierProvider<GoldPriceNotifier, AsyncValue<double>>((ref) {
  return GoldPriceNotifier();
});

class GoldPriceNotifier extends StateNotifier<AsyncValue<double>> {
  static const String _priceKey = 'gold_price_sar';
  static const double _defaultPrice = 320.0; // SAR per gram 24K

  GoldPriceNotifier() : super(const AsyncValue.loading()) {
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_priceKey);
    state = AsyncValue.data(saved ?? _defaultPrice);
  }

  Future<void> setPrice(double price) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_priceKey, price);
    state = AsyncValue.data(price);
  }

  Future<void> fetchFromApi() async {
    state = const AsyncValue.loading();
    try {
      // Using a free gold price API
      final response = await http
          .get(Uri.parse(
              'https://api.gold-api.com/price/XAU'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Price in USD per troy ounce -> convert to SAR per gram
        final priceUsdPerOz = (data['price'] as num).toDouble();
        const usdToSar = 3.75;
        const ozToGram = 31.1035;
        final pricePerGram24K = (priceUsdPerOz / ozToGram) * usdToSar;
        await setPrice(double.parse(pricePerGram24K.toStringAsFixed(2)));
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      // Keep existing price on error
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getDouble(_priceKey) ?? _defaultPrice;
      state = AsyncValue.data(saved);
    }
  }
}

// Zakat calculation state
class ZakatInfo {
  final double totalWeightGrams;
  final double totalWeight24K;
  final double totalValue;
  final bool hasReachedNisaab;
  final double zakatAmount;
  final double goldPricePerGram;

  const ZakatInfo({
    required this.totalWeightGrams,
    required this.totalWeight24K,
    required this.totalValue,
    required this.hasReachedNisaab,
    required this.zakatAmount,
    required this.goldPricePerGram,
  });
}

final zakatInfoProvider = Provider<ZakatInfo>((ref) {
  final items = ref.watch(goldListProvider);
  final priceAsync = ref.watch(goldPriceProvider);
  final pricePerGram = priceAsync.valueOrNull ?? 320.0;

  final itemMaps = items.map((e) => e.toMap()).toList();
  final totalWeightGrams =
      items.fold(0.0, (sum, item) => sum + item.weight);
  final total24K = GoldCalculator.totalWeight24K(itemMaps);
  final totalValue = GoldCalculator.totalValue(itemMaps, pricePerGram);
  final nisaabReached = GoldCalculator.hasReachedNisaab(total24K);
  final zakatAmount =
      nisaabReached ? GoldCalculator.calculateZakat(totalValue) : 0.0;

  return ZakatInfo(
    totalWeightGrams: totalWeightGrams,
    totalWeight24K: total24K,
    totalValue: totalValue,
    hasReachedNisaab: nisaabReached,
    zakatAmount: zakatAmount,
    goldPricePerGram: pricePerGram,
  );
});
