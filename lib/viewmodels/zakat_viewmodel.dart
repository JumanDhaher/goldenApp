import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/gold_calculator.dart';
import 'gold_list_viewmodel.dart';

// ══════════════════════════════════════════════════════════════
// GoldPriceState
// ══════════════════════════════════════════════════════════════
class GoldPriceState {
  final double price;        // سعر جرام عيار 24 بالريال
  final bool isLoading;
  final String? lastUpdated; // وقت آخر تحديث
  final String? error;

  const GoldPriceState({
    this.price = 320.0,
    this.isLoading = false,
    this.lastUpdated,
    this.error,
  });

  GoldPriceState copyWith({
    double? price,
    bool? isLoading,
    String? lastUpdated,
    String? error,
  }) =>
      GoldPriceState(
        price: price ?? this.price,
        isLoading: isLoading ?? this.isLoading,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        error: error,
      );

  /// سعر أي عيار محسوب من عيار 24
  double karatPrice(int karat) => price * (karat / 24.0);
}

// ══════════════════════════════════════════════════════════════
// GoldPriceNotifier — يجرب 3 مصادر بالترتيب
// ══════════════════════════════════════════════════════════════
final goldPriceProvider =
    StateNotifierProvider<GoldPriceNotifier, GoldPriceState>((ref) {
  return GoldPriceNotifier();
});

class GoldPriceNotifier extends StateNotifier<GoldPriceState> {
  static const String _priceKey = 'gold_price_sar';
  static const double _fallback = 320.0;

  // headers مشتركة لتجنب 403
  static const Map<String, String> _headers = {
    'x-access-token': 'goldprice-org',
    'User-Agent':
        'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15',
    'Accept': 'application/json',
    'Origin': 'https://goldprice.org',
    'Referer': 'https://goldprice.org/',
  };

  Timer? _autoRefreshTimer;

  GoldPriceNotifier() : super(const GoldPriceState()) {
    _init();
  }

  Future<void> _init() async {
    // عرض آخر سعر محفوظ فوراً
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_priceKey);
    if (saved != null) {
      state = state.copyWith(price: saved);
    }

    // اجلب السعر الحالي، ثم كل دقيقة تلقائياً
    await fetchFromApi();
    _autoRefreshTimer =
        Timer.periodic(const Duration(minutes: 1), (_) => fetchFromApi());
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  /// يجرب 3 مصادر بالترتيب حتى ينجح واحد
  Future<void> fetchFromApi() async {
    state = state.copyWith(isLoading: true, error: null);

    double? price;

    // ── المصدر ١: goldprice.org (نفس الموقع) ──────────────
    price ??= await _tryGoldPriceOrg();

    // ── المصدر ٢: gold-api.com (مجاني بدون مفتاح) ─────────
    price ??= await _tryGoldApiCom();

    // ── المصدر ٣: metals-live (fallback) ──────────────────
    price ??= await _tryMetalsLive();

    if (price != null && price > 0) {
      await _savePrice(price);
      state = state.copyWith(
        price: price,
        isLoading: false,
        lastUpdated: _timeNow(),
        error: null,
      );
    } else {
      // استخدم آخر سعر محفوظ إذا فشل كل شيء
      state = state.copyWith(
        isLoading: false,
        error: 'تعذّر تحديث السعر',
      );
    }
  }

  // ── المصدر ١: goldprice.org ────────────────────────────
  Future<double?> _tryGoldPriceOrg() async {
    try {
      final res = await http
          .get(
            Uri.parse('https://data-asg.goldprice.org/dbXRates/SAR'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final xauPrice = (data['items'][0]['xauPrice'] as num).toDouble();
        return xauPrice / 31.1035; // XAU per oz → SAR per gram
      }
    } catch (_) {}
    return null;
  }

  // ── المصدر ٢: gold-api.com ─────────────────────────────
  Future<double?> _tryGoldApiCom() async {
    try {
      final res = await http
          .get(Uri.parse('https://api.gold-api.com/price/XAU'))
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        // السعر بالدولار لكل أونصة → ريال للجرام
        final priceUsd = (data['price'] as num).toDouble();
        const sarPerUsd = 3.75;
        const gramsPerOz = 31.1035;
        return (priceUsd / gramsPerOz) * sarPerUsd;
      }
    } catch (_) {}
    return null;
  }

  // ── المصدر ٣: metals-api (live price) ─────────────────
  Future<double?> _tryMetalsLive() async {
    try {
      final res = await http
          .get(Uri.parse(
              'https://api.metalpriceapi.com/v1/latest?api_key=demo&base=XAU&currencies=SAR'))
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        // SAR per XAU (أونصة) → SAR per gram
        final sarPerOz = (data['rates']['SAR'] as num).toDouble();
        return sarPerOz / 31.1035;
      }
    } catch (_) {}
    return null;
  }

  /// إدخال السعر يدوياً
  Future<void> setManualPrice(double price) async {
    await _savePrice(price);
    state = state.copyWith(
      price: price,
      lastUpdated: _timeNow(),
      error: null,
    );
  }

  Future<void> _savePrice(double price) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_priceKey, price);
  }

  String _timeNow() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

// ══════════════════════════════════════════════════════════════
// ZakatInfo
// ══════════════════════════════════════════════════════════════
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

  double karatPrice(int karat) => goldPricePerGram * (karat / 24.0);
}

final zakatInfoProvider = Provider<ZakatInfo>((ref) {
  final items        = ref.watch(goldListProvider);
  final priceState   = ref.watch(goldPriceProvider);
  final pricePerGram = priceState.price;

  final itemMaps         = items.map((e) => e.toMap()).toList();
  final totalWeightGrams = items.fold(0.0, (s, i) => s + i.weight);
  final total24K         = GoldCalculator.totalWeight24K(itemMaps);
  final totalValue       = GoldCalculator.totalValue(itemMaps, pricePerGram);
  final nisaabReached    = GoldCalculator.hasReachedNisaab(total24K);
  final zakatAmount =
      nisaabReached ? GoldCalculator.calculateZakat(totalValue) : 0.0;

  return ZakatInfo(
    totalWeightGrams:  totalWeightGrams,
    totalWeight24K:    total24K,
    totalValue:        totalValue,
    hasReachedNisaab:  nisaabReached,
    zakatAmount:       zakatAmount,
    goldPricePerGram:  pricePerGram,
  );
});
