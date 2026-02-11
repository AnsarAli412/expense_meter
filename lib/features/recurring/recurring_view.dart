import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'recurring_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/transaction_model.dart';
import 'add_recurring_view.dart';

class RecurringView extends GetView<RecurringController> {
  const RecurringView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recurring Entries')),
      body: Obx(() {
        if (controller.entries.isEmpty) {
          return const Center(child: Text('No recurring entries'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.entries.length,
          itemBuilder: (context, index) {
            final entry = controller.entries[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: entry.type == TransactionType.income
                      ? AppColors.income
                      : AppColors.expense,
                  child: Icon(
                    entry.type == TransactionType.income
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
                title: Text('₹${entry.amount.toStringAsFixed(2)}'),
                subtitle: Text(
                  'Next due: ${DateFormat.yMMMd().format(entry.nextDueDate)}',
                ),
                trailing: Switch(
                  value: entry.isActive,
                  onChanged: (val) => controller.toggleActive(entry, val),
                ),
                onLongPress: () => controller.deleteEntry(entry),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddRecurringView());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
