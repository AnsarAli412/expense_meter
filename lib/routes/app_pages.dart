import 'package:get/get.dart';
import 'app_routes.dart';
// Features will be imported here
import '../features/splash/splash_binding.dart';
import '../features/splash/splash_view.dart';
import '../features/onboarding/onboarding_binding.dart';
import '../features/onboarding/onboarding_view.dart';
import '../features/profile_setup/profile_setup_binding.dart';
import '../features/profile_setup/profile_setup_view.dart';
import '../features/dashboard/dashboard_binding.dart';
import '../features/dashboard/dashboard_view.dart';
import '../features/income/income_binding.dart';
import '../features/income/income_view.dart';
import '../features/expense/expense_binding.dart';
import '../features/expense/expense_view.dart';
import '../features/category/category_binding.dart';
import '../features/category/category_view.dart';
import '../features/settings/settings_binding.dart';
import '../features/settings/settings_view.dart';
import '../features/reports/reports_binding.dart';
import '../features/reports/reports_view.dart';
import '../features/recurring/recurring_binding.dart';
import '../features/recurring/recurring_view.dart';
import '../features/reports/yearly_report_binding.dart';
import '../features/reports/yearly_report_view.dart';
import '../features/transactions/transactions_binding.dart';
import '../features/transactions/transactions_view.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.PROFILE_SETUP,
      page: () => const ProfileSetupView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.ADD_INCOME,
      page: () => const IncomeView(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.ADD_EXPENSE,
      page: () => const ExpenseView(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: Routes.MONTHLY_REPORT,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY_MANAGEMENT,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.RECURRING_ENTRIES,
      page: () => const RecurringView(),
      binding: RecurringBinding(),
    ),
    GetPage(
      name: Routes.YEARLY_OVERVIEW,
      page: () => const YearlyReportView(),
      binding: YearlyReportBinding(),
    ),
    GetPage(
      name: Routes.TRANSACTIONS,
      page: () => const TransactionsView(),
      binding: TransactionsBinding(),
    ),
  ];
}
