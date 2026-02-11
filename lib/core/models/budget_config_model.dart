import 'package:hive/hive.dart';

part 'budget_config_model.g.dart';

@HiveType(typeId: 7)
class BudgetConfig extends HiveObject {
  @HiveField(0)
  double needsPercentage;

  @HiveField(1)
  double wantsPercentage;

  @HiveField(2)
  double savingsPercentage;

  BudgetConfig({
    this.needsPercentage = 50.0,
    this.wantsPercentage = 30.0,
    this.savingsPercentage = 20.0,
  });
}
