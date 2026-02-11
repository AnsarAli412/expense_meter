import 'package:get/get.dart';
// For Colors
import '../../core/services/hive_service.dart';
import '../../core/models/transaction_model.dart';
import '../../core/models/category_model.dart';
import '../../core/models/budget_config_model.dart';
import '../../routes/app_routes.dart';

class DashboardController extends GetxController {
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble balance = 0.0.obs;

  final RxDouble needsSpent = 0.0.obs;
  final RxDouble wantsSpent = 0.0.obs;
  final RxDouble savingsSpent = 0.0.obs;

  final RxDouble needsTarget = 0.0.obs;
  final RxDouble wantsTarget = 0.0.obs;
  final RxDouble savingsTarget = 0.0.obs;

  final RxList<Transaction> recentTransactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() {
    final transactions = HiveService.transactionsBox.values
        .toList()
        .cast<Transaction>();
    final categories = HiveService.categoriesBox.values
        .toList()
        .cast<Category>();
    final config =
        HiveService.budgetBox.getAt(0) as BudgetConfig; // Assumes seeded

    final now = DateTime.now();
    final currentMonthTransactions = transactions.where((t) {
      return t.date.year == now.year && t.date.month == now.month;
    }).toList();

    double income = 0;
    double expense = 0;
    double needs = 0;
    double wants = 0;
    double savings = 0;

    // Sort by date desc
    currentMonthTransactions.sort((a, b) => b.date.compareTo(a.date));
    recentTransactions.assignAll(currentMonthTransactions.take(5));

    for (var t in currentMonthTransactions) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;

        // Categorize
        if (t.categoryId != null) {
          final cat = categories.firstWhereOrNull((c) => c.id == t.categoryId);
          if (cat != null) {
            if (cat.type == 'needs') {
              needs += t.amount;
            } else if (cat.type == 'wants')
              wants += t.amount;
            else if (cat.type == 'savings')
              savings += t.amount;
          }
        }
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    balance.value = income - expense;

    needsSpent.value = needs;
    wantsSpent.value = wants;
    savingsSpent.value = savings;

    // Targets
    needsTarget.value = income * (config.needsPercentage / 100);
    wantsTarget.value = income * (config.wantsPercentage / 100);
    savingsTarget.value = income * (config.savingsPercentage / 100);
  }

  void refreshData() {
    loadDashboardData();
  }

  void goToAddIncome() async {
    await Get.toNamed(Routes.ADD_INCOME);
    refreshData();
  }

  void goToAddExpense() async {
    await Get.toNamed(Routes.ADD_EXPENSE);
    refreshData();
  }
}
