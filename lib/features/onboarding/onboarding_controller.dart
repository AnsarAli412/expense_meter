import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Welcome to Expense Meter',
      description:
          'Master your finances with the proven 50/30/20 budgeting rule.',
      icon: Icons.account_balance_wallet_rounded,
    ),
    OnboardingPageModel(
      title: 'The 50/30/20 Rule',
      description:
          '50% Needs: Essentials\n30% Wants: Lifestyle\n20% Savings: Future',
      icon: Icons.pie_chart_rounded,
    ),
    OnboardingPageModel(
      title: 'Track Offline',
      description:
          'Your data stays on your device. Secure, private, and always accessible.',
      icon: Icons.lock_outline_rounded,
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      completeOnboarding();
    }
  }

  void skip() {
    completeOnboarding();
  }

  void completeOnboarding() {
    // We don't mark onboarding as completed here primarily because we need profile setup.
    // Or we can mark it as part of profile setup.
    // If we go to Profile Setup, user hasn't finished "setup" yet.
    Get.toNamed(Routes.PROFILE_SETUP);
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}
