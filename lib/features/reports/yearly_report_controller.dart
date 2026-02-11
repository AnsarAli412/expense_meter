import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/models/transaction_model.dart';
import '../../core/services/hive_service.dart';
import '../../core/constants/app_colors.dart';

class YearlyReportController extends GetxController {
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxList<BarChartGroupData> monthlyBars = <BarChartGroupData>[].obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    generateReport();
  }

  void generateReport() {
    final transactions = HiveService.transactionsBox.values
        .toList()
        .cast<Transaction>();
    final yearTransactions = transactions
        .where((t) => t.date.year == selectedYear.value)
        .toList();

    double income = 0;
    double expense = 0;
    Map<int, double> monthlyIncome = {};
    Map<int, double> monthlyExpense = {};

    for (var t in yearTransactions) {
      if (t.type == TransactionType.income) {
        income += t.amount;
        monthlyIncome.update(
          t.date.month,
          (val) => val + t.amount,
          ifAbsent: () => t.amount,
        );
      } else {
        expense += t.amount;
        monthlyExpense.update(
          t.date.month,
          (val) => val + t.amount,
          ifAbsent: () => t.amount,
        );
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    monthlyBars.clear();

    for (int i = 1; i <= 12; i++) {
      final inc = monthlyIncome[i] ?? 0.0;
      final exp = monthlyExpense[i] ?? 0.0;

      monthlyBars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: inc, color: AppColors.income, width: 8),
            BarChartRodData(toY: exp, color: AppColors.expense, width: 8),
          ],
        ),
      );
    }
  }

  void prevYear() {
    selectedYear.value--;
    generateReport();
  }

  void nextYear() {
    selectedYear.value++;
    generateReport();
  }
}
