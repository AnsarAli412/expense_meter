import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'expense_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/category_model.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: controller.amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: const Icon(Icons.money_off),
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

                // Category Dropdown
                Obx(
                  () => DropdownButtonFormField<Category>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: controller.selectedCategory.value,
                    items: controller.categories.map((Category cat) {
                      return DropdownMenuItem<Category>(
                        value: cat,
                        child: Text('${cat.name} (${cat.type.toUpperCase()})'),
                      );
                    }).toList(),
                    onChanged: controller.onCategoryChanged,
                    validator: (value) =>
                        value == null ? 'Select category' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // SubCategory Dropdown (Conditional)
                Obx(() {
                  if (controller.selectedCategory.value == null ||
                      controller.subCategories.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      DropdownButtonFormField<SubCategory>(
                        decoration: InputDecoration(
                          labelText: 'Sub-Category (Optional)',
                          prefixIcon: const Icon(
                            Icons.subdirectory_arrow_right,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialValue: controller.selectedSubCategory.value,
                        items: controller.subCategories.map((SubCategory sub) {
                          return DropdownMenuItem<SubCategory>(
                            value: sub,
                            child: Text(sub.name),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            controller.selectedSubCategory.value = val,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),

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
                            DateFormat.yMMMd().format(
                              controller.selectedDate.value,
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

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

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.expense,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Save Expense',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
