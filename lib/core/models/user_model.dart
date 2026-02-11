import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String currency;

  @HiveField(2)
  bool onboardingCompleted;

  @HiveField(3)
  bool isDarkMode;

  User({
    required this.name,
    required this.currency,
    this.onboardingCompleted = false,
    this.isDarkMode = false,
  });
}
