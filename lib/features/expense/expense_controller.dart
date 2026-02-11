import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/transaction_model.dart';
import '../../core/models/category_model.dart';
import '../../core/services/hive_service.dart';

class ExpenseController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final Rx<SubCategory?> selectedSubCategory = Rx<SubCategory?>(null);

  final RxList<Category> categories = <Category>[].obs;
  final RxList<SubCategory> subCategories = <SubCategory>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = HiveService.categoriesBox.values
        .toList()
        .cast<Category>();
  }

  void onCategoryChanged(Category? category) {
    selectedCategory.value = category;
    selectedSubCategory.value = null; // Reset subcategory
    if (category != null) {
      subCategories.value = category.subCategories;
    } else {
      subCategories.clear();
    }
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void saveExpense() async {
    if (formKey.currentState!.validate()) {
      if (selectedCategory.value == null) {
        Get.snackbar(
          'Error',
          'Please select a category',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final amount = double.tryParse(amountController.text) ?? 0.0;
      final note = noteController.text.trim();

      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: amount,
        type: TransactionType.expense,
        date: selectedDate.value,
        categoryId: selectedCategory.value!.id,
        subCategoryId: selectedSubCategory.value?.id,
        note: note,
      );

      await HiveService.transactionsBox.add(transaction);
      Get.back();
      Get.snackbar(
        'Success',
        'Expense added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
