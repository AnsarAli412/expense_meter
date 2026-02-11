import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/models/transaction_model.dart';
import '../../core/models/category_model.dart';
import '../../core/services/hive_service.dart';

class ReportsController extends GetxController {
  final RxList<PieChartSectionData> pieChartSections =
      <PieChartSectionData>[].obs;
  final RxList<CategorySpending> categorySpending = <CategorySpending>[].obs;
  final RxDouble totalExpense = 0.0.obs;
  final Rx<DateTime> currentMonth = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    generateReport();
  }

  void generateReport() {
    final transactions = HiveService.transactionsBox.values
        .toList()
        .cast<Transaction>();
    final categories = HiveService.categoriesBox.values
        .toList()
        .cast<Category>();

    final monthTransactions = transactions.where((t) {
      return t.type == TransactionType.expense &&
          t.date.year == currentMonth.value.year &&
          t.date.month == currentMonth.value.month;
    }).toList();

    double total = 0;
    Map<String, double> spendingByCategory = {};

    for (var t in monthTransactions) {
      total += t.amount;
      if (t.categoryId != null) {
        spendingByCategory.update(
          t.categoryId!,
          (value) => value + t.amount,
          ifAbsent: () => t.amount,
        );
      }
    }

    totalExpense.value = total;
    categorySpending.clear();
    pieChartSections.clear();

    spendingByCategory.forEach((catId, amount) {
      final cat = categories.firstWhereOrNull((c) => c.id == catId);
      if (cat != null) {
        categorySpending.add(CategorySpending(category: cat, amount: amount));

        pieChartSections.add(
          PieChartSectionData(
            color: Color(cat.colorCode), // Assuming colorCode is int 0xFF...
            value: amount,
            title: '${((amount / total) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    });

    // Sort by amount desc
    categorySpending.sort((a, b) => b.amount.compareTo(a.amount));
  }

  void prevMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
    generateReport();
  }

  void nextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
    generateReport();
  }
}

class CategorySpending {
  final Category category;
  final double amount;

  CategorySpending({required this.category, required this.amount});
}
