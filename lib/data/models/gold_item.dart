import 'package:hive/hive.dart';

part 'gold_item.g.dart';

@HiveType(typeId: 0)
class GoldItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type; // ring, bar, necklace, other

  @HiveField(3)
  int karat; // 18, 21, 22, 24

  @HiveField(4)
  double weight; // grams

  @HiveField(5)
  double purchasePrice;

  @HiveField(6)
  DateTime purchaseDate;

  @HiveField(7)
  String? imagePath;

  @HiveField(8)
  String? notes;

  @HiveField(9)
  DateTime createdAt;

  GoldItem({
    required this.id,
    required this.name,
    required this.type,
    required this.karat,
    required this.weight,
    required this.purchasePrice,
    required this.purchaseDate,
    this.imagePath,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  GoldItem copyWith({
    String? id,
    String? name,
    String? type,
    int? karat,
    double? weight,
    double? purchasePrice,
    DateTime? purchaseDate,
    String? imagePath,
    String? notes,
  }) {
    return GoldItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      karat: karat ?? this.karat,
      weight: weight ?? this.weight,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'karat': karat,
        'weight': weight,
        'purchasePrice': purchasePrice,
        'purchaseDate': purchaseDate.toIso8601String(),
        'imagePath': imagePath,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };
}
