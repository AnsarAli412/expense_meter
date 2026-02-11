import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../core/models/transaction_model.dart';
import '../../core/models/category_model.dart';
import '../../core/constants/app_strings.dart';
import 'package:intl/intl.dart';

class TransactionsController extends GetxController {
  final _transactionsBox = Hive.box<Transaction>(AppStrings.transactionsBox);
  final _categoriesBox = Hive.box<Category>(AppStrings.categoriesBox);

  // Observable lists
  final allTransactions = <Transaction>[].obs;
  final filteredTransactions = <Transaction>[].obs;

  // Filter observables
  final selectedMonth = Rx<DateTime?>(null);
  final selectedCategoryId = Rx<String?>(null);
  final selectedType = Rx<TransactionType?>(null);

  // Available categories for filter
  final categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadTransactions();

    // Set default to current month
    selectedMonth.value = DateTime.now();
    applyFilters();
  }

  void loadCategories() {
    categories.value = _categoriesBox.values.toList();
  }

  void loadTransactions() {
    allTransactions.value = _transactionsBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Newest first
    applyFilters();
  }

  void applyFilters() {
    var filtered = allTransactions.toList();

    // Filter by month
    if (selectedMonth.value != null) {
      final month = selectedMonth.value!;
      filtered = filtered.where((t) {
        return t.date.year == month.year && t.date.month == month.month;
      }).toList();
    }

    // Filter by category
    if (selectedCategoryId.value != null) {
      filtered = filtered
          .where((t) => t.categoryId == selectedCategoryId.value)
          .toList();
    }

    // Filter by type
    if (selectedType.value != null) {
      filtered = filtered.where((t) => t.type == selectedType.value).toList();
    }

    filteredTransactions.value = filtered;
  }

  void setMonthFilter(DateTime? month) {
    selectedMonth.value = month;
    applyFilters();
  }

  void setCategoryFilter(String? categoryId) {
    selectedCategoryId.value = categoryId;
    applyFilters();
  }

  void setTypeFilter(TransactionType? type) {
    selectedType.value = type;
    applyFilters();
  }

  void clearFilters() {
    selectedMonth.value = DateTime.now();
    selectedCategoryId.value = null;
    selectedType.value = null;
    applyFilters();
  }

  String getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Uncategorized';
    final category = categories.firstWhereOrNull((c) => c.id == categoryId);
    return category?.name ?? 'Unknown';
  }

  Future<void> refreshData() async {
    loadCategories();
    loadTransactions();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}
