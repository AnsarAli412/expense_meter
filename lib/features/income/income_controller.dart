import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/transaction_model.dart';
import '../../core/services/hive_service.dart';

class IncomeController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController sourceController =
      TextEditingController(); // Optional source
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  void saveIncome() async {
    if (formKey.currentState!.validate()) {
      final amount = double.tryParse(amountController.text) ?? 0.0;
      final source = sourceController.text.trim();

      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: amount,
        type: TransactionType.income,
        date: selectedDate.value,
        source: source.isNotEmpty ? source : 'Income',
      );

      await HiveService.transactionsBox.add(transaction);
      Get.back();
      Get.snackbar(
        'Success',
        'Income added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
