import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/user_model.dart';
import '../../core/services/hive_service.dart';
import '../../routes/app_routes.dart';

class ProfileSetupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Hardcoded currency for India
  final String defaultCurrency = '₹';

  void saveProfile() async {
    if (formKey.currentState!.validate()) {
      final name = nameController.text.trim();

      final user = User(
        name: name,
        currency: defaultCurrency,
        onboardingCompleted: true,
        isDarkMode: Get.isDarkMode,
      );

      final userBox = HiveService.userBox;
      await userBox.clear(); // Ensure only one user
      await userBox.add(user);

      Get.offAllNamed(Routes.DASHBOARD);
    }
  }
}
