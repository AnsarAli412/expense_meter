import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/services/hive_service.dart';
import '../../core/models/budget_config_model.dart';
import '../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final RxDouble needsPercent = 50.0.obs;
  final RxDouble wantsPercent = 30.0.obs;
  final RxDouble savingsPercent = 20.0.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    final config = HiveService.budgetBox.getAt(0) as BudgetConfig;
    needsPercent.value = config.needsPercentage;
    wantsPercent.value = config.wantsPercentage;
    savingsPercent.value = config.savingsPercentage;
    isDarkMode.value = Get.isDarkMode;
  }

  void updatePercentages() async {
    final total =
        needsPercent.value + wantsPercent.value + savingsPercent.value;
    if ((total - 100).abs() > 0.1) {
      Get.snackbar(
        'Error',
        'Percentages must add up to 100%. Current: ${total.toStringAsFixed(0)}%',
      );
      return;
    }

    final config = HiveService.budgetBox.getAt(0) as BudgetConfig;
    config.needsPercentage = needsPercent.value;
    config.wantsPercentage = wantsPercent.value;
    config.savingsPercentage = savingsPercent.value;
    await config.save();

    Get.snackbar('Success', 'Budget settings saved');
  }

  void toggleTheme(bool val) {
    isDarkMode.value = val;
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
  }

  void resetData() {
    Get.defaultDialog(
      title: 'Reset App Data',
      middleText:
          'Are you sure? This will delete all transactions and categories. This cannot be undone.',
      textConfirm: 'Reset',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await HiveService.clearAll();
        Get.offAllNamed(Routes.SPLASH);
      },
    );
  }
}
