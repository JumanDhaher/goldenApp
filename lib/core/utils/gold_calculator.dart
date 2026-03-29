class GoldCalculator {
  GoldCalculator._();

  /// Nisaab threshold in grams (85g of 24K gold)
  static const double nisaabGrams = 85.0;

  /// Zakat rate (2.5%)
  static const double zakatRate = 0.025;

  /// Convert gold weight from any karat to 24K equivalent
  static double convertTo24K(double weightGrams, int karat) {
    return weightGrams * (karat / 24.0);
  }

  /// Calculate total 24K equivalent weight from a list of items
  static double totalWeight24K(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (sum, item) {
      final weight = (item['weight'] as double?) ?? 0.0;
      final karat = (item['karat'] as int?) ?? 24;
      return sum + convertTo24K(weight, karat);
    });
  }

  /// Check if gold has reached nisaab
  static bool hasReachedNisaab(double totalWeight24K) {
    return totalWeight24K >= nisaabGrams;
  }

  /// Calculate zakat amount in currency
  static double calculateZakat(double totalValue) {
    return totalValue * zakatRate;
  }

  /// Calculate approximate value of gold
  static double calculateValue(
    double weightGrams,
    int karat,
    double pricePerGram24K,
  ) {
    final weight24K = convertTo24K(weightGrams, karat);
    return weight24K * pricePerGram24K;
  }

  /// Calculate total value of all gold items
  static double totalValue(
    List<Map<String, dynamic>> items,
    double pricePerGram24K,
  ) {
    return items.fold(0.0, (sum, item) {
      final weight = (item['weight'] as double?) ?? 0.0;
      final karat = (item['karat'] as int?) ?? 24;
      return sum + calculateValue(weight, karat, pricePerGram24K);
    });
  }
}
