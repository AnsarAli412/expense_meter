import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transactions_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionsView extends GetView<TransactionsController> {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_off),
            onPressed: controller.clearFilters,
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshData,
              child: Obx(() {
                if (controller.filteredTransactions.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildTransactionList();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Obx(() => _buildMonthPicker(context))),
              const SizedBox(width: 12),
              Expanded(child: Obx(() => _buildCategoryFilter(context))),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => _buildTypeFilter()),
        ],
      ),
    );
  }

  Widget _buildMonthPicker(BuildContext context) {
    return InkWell(
      onTap: () => _showMonthPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.selectedMonth.value != null
                  ? DateFormat(
                      'MMM yyyy',
                    ).format(controller.selectedMonth.value!)
                  : 'All Months',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            Icon(
              Icons.calendar_today,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return DropdownButtonFormField<String?>(
      value: controller.selectedCategoryId.value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      hint: const Text('All Categories'),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Categories')),
        ...controller.categories.map((category) {
          return DropdownMenuItem(
            value: category.id,
            child: Text(category.name),
          );
        }),
      ],
      onChanged: controller.setCategoryFilter,
    );
  }

  Widget _buildTypeFilter() {
    return Row(
      children: [
        Expanded(child: _buildTypeChip('All', null)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeChip('Income', TransactionType.income)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeChip('Expense', TransactionType.expense)),
      ],
    );
  }

  Widget _buildTypeChip(String label, TransactionType? type) {
    final isSelected = controller.selectedType.value == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.setTypeFilter(type),
      selectedColor: AppColors.primary.withAlpha(51),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = controller.filteredTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? AppColors.income : AppColors.expense;
    final categoryName = controller.getCategoryName(transaction.categoryId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.formatDate(transaction.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isIncome ? '+' : '-'}${controller.formatAmount(transaction.amount)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  transaction.note!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (transaction.source != null &&
                  transaction.source!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Source: ${transaction.source}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Transactions Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedMonth.value ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      controller.setMonthFilter(picked);
    }
  }
}
