import 'package:get/get.dart';
import '../../core/services/hive_service.dart';
import '../../routes/app_routes.dart';
import '../../core/models/user_model.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 2));

    final userBox = HiveService.userBox;

    // Check if user exists
    if (userBox.isEmpty) {
      Get.offAllNamed(Routes.ONBOARDING);
    } else {
      final User user = userBox.getAt(0) as User;
      if (!user.onboardingCompleted) {
        Get.offAllNamed(Routes.ONBOARDING);
      } else {
        Get.offAllNamed(Routes.DASHBOARD);
      }
    }
  }
}
