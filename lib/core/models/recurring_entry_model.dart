import 'package:hive/hive.dart';
import 'transaction_model.dart'; // Import for TransactionType

part 'recurring_entry_model.g.dart';

@HiveType(typeId: 5)
enum RecurringInterval {
  @HiveField(0)
  monthly,
  @HiveField(1)
  yearly,
}

@HiveType(typeId: 6)
class RecurringEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  TransactionType type;

  @HiveField(3)
  String? categoryId;

  @HiveField(4)
  String? subCategoryId;

  @HiveField(5)
  RecurringInterval interval;

  @HiveField(6)
  DateTime nextDueDate;

  @HiveField(7)
  String? note;

  @HiveField(8)
  String? source;

  @HiveField(9)
  bool isActive;

  RecurringEntry({
    required this.id,
    required this.amount,
    required this.type,
    this.categoryId,
    this.subCategoryId,
    required this.interval,
    required this.nextDueDate,
    this.note,
    this.source,
    this.isActive = true,
  });
}
