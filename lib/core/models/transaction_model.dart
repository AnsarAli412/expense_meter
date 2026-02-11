import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 3)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 4)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  TransactionType type;

  @HiveField(3)
  String? categoryId; // Nullable for income if not using categories

  @HiveField(4)
  String? subCategoryId;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String? note;

  @HiveField(7)
  String? source; // For income

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    this.categoryId,
    this.subCategoryId,
    required this.date,
    this.note,
    this.source,
  });
}
