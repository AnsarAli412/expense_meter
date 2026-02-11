import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name; // Needs, Wants, Savings (or custom)

  @HiveField(2)
  String type; // 'needs', 'wants', 'savings' (enum stringified)

  @HiveField(3)
  List<SubCategory> subCategories;

  @HiveField(4)
  int colorCode; // Store color as int

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.subCategories,
    required this.colorCode,
  });
}

@HiveType(typeId: 2)
class SubCategory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String parentCategoryId;

  SubCategory({
    required this.id,
    required this.name,
    required this.parentCategoryId,
  });
}
