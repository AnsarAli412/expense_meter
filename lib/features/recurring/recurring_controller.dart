import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/recurring_entry_model.dart';
import '../../core/models/transaction_model.dart';
import '../../core/services/hive_service.dart';

class RecurringController extends GetxController {
  final RxList<RecurringEntry> entries = <RecurringEntry>[].obs;

  // Form Controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final Rx<TransactionType> selectedType = TransactionType.expense.obs;
  final Rx<RecurringInterval> selectedInterval = RecurringInterval.monthly.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  void loadEntries() {
    entries.value = HiveService.recurringBox.values
        .toList()
        .cast<RecurringEntry>();
  }

  void toggleActive(RecurringEntry entry, bool val) async {
    entry.isActive = val;
    await entry.save();
    entries.refresh();
  }

  void deleteEntry(RecurringEntry entry) async {
    await entry.delete();
    loadEntries();
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void saveRecurringEntry() async {
    if (formKey.currentState!.validate()) {
      final amount = double.tryParse(amountController.text) ?? 0.0;
      final note = noteController.text.trim();

      final entry = RecurringEntry(
        id: const Uuid().v4(),
        amount: amount,
        type: selectedType.value,
        interval: selectedInterval.value,
        nextDueDate: selectedDate.value,
        note: note,
        isActive: true, // Default to active
      );

      await HiveService.recurringBox.add(entry);
      Get.back(); // Close the add screen
      loadEntries(); // Refresh list
      Get.snackbar(
        'Success',
        'Recurring entry added',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Reset form
      amountController.clear();
      noteController.clear();
      selectedType.value = TransactionType.expense;
      selectedDate.value = DateTime.now();
    }
  }
}
