import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'recurring_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/transaction_model.dart';
import '../../core/models/recurring_entry_model.dart';

class AddRecurringView extends GetView<RecurringController> {
  const AddRecurringView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recurring Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Amount
              TextFormField(
                controller: controller.amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter amount';
                  if (double.tryParse(value) == null) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Transaction Type Toggle
              Obx(
                () => SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Income'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('Expense'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {controller.selectedType.value},
                  onSelectionChanged: (Set<TransactionType> newSelection) {
                    controller.selectedType.value = newSelection.first;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Interval Dropdown
              Obx(
                () => DropdownButtonFormField<RecurringInterval>(
                  decoration: InputDecoration(
                    labelText: 'Interval',
                    prefixIcon: const Icon(Icons.repeat),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: controller.selectedInterval.value,
                  items: RecurringInterval.values.map((interval) {
                    return DropdownMenuItem(
                      value: interval,
                      child: Text(
                        interval.toString().split('.').last.toUpperCase(),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedInterval.value = val;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Next Due Date Picker
              InkWell(
                onTap: () => controller.pickDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Obx(
                        () => Text(
                          'Next Due: ${DateFormat.yMMMd().format(controller.selectedDate.value)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: controller.noteController,
                decoration: InputDecoration(
                  labelText: 'Note (Optional)',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.saveRecurringEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.selectedType.value ==
                              TransactionType.income
                          ? AppColors.income
                          : AppColors.expense,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Save Entry',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
