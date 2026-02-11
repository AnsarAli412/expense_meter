import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/transaction_model.dart';
import 'package:intl/intl.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              _buildSummaryCard(context),
              const SizedBox(height: 24),

              // 50/30/20 Progress
              Text(
                'Budget Status',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildBudgetCard(
                'Needs (50%)',
                controller.needsSpent,
                controller.needsTarget,
                AppColors.needsColor,
              ),
              const SizedBox(height: 12),
              _buildBudgetCard(
                'Wants (30%)',
                controller.wantsSpent,
                controller.wantsTarget,
                AppColors.tertiary,
              ),
              const SizedBox(height: 12),
              _buildBudgetCard(
                'Savings (20%)',
                controller.savingsSpent,
                controller.savingsTarget,
                AppColors.secondary,
              ),

              const SizedBox(height: 24),

              // Recent Transactions
              Text(
                'Recent Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.recentTransactions.isEmpty) {
                  return const Center(child: Text('No recent transactions'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.recentTransactions.length,
                  itemBuilder: (context, index) {
                    final t = controller.recentTransactions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: t.type == TransactionType.income
                            ? AppColors.income.withValues(alpha: 0.1)
                            : AppColors.expense.withValues(alpha: 0.1),
                        child: Icon(
                          t.type == TransactionType.income
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: t.type == TransactionType.income
                              ? AppColors.income
                              : AppColors.expense,
                        ),
                      ),
                      title: Text(
                        t.type == TransactionType.income
                            ? (t.source ?? 'Income')
                            : 'Expense',
                      ),
                      subtitle: Text(DateFormat.yMMMd().format(t.date)),
                      trailing: Text(
                        '${t.type == TransactionType.income ? '+' : '-'}₹${t.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: t.type == TransactionType.income
                              ? AppColors.income
                              : AppColors.expense,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 16),
              // View All Transactions Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/transactions'),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('View All Transactions'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'income',
            onPressed: () => Get.toNamed('/add_income'),
            icon: const Icon(Icons.add),
            label: const Text('Income'),
            backgroundColor: AppColors.income,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'expense',
            onPressed: () => Get.toNamed('/add_expense'),
            icon: const Icon(Icons.remove),
            label: const Text('Expense'),
            backgroundColor: AppColors.expense,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Balance',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer.withAlpha(179),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                '₹${controller.balance.value.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Income',
                  controller.totalIncome,
                  AppColors.income,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                _buildSummaryItem(
                  'Expense',
                  controller.totalExpense,
                  AppColors.expense,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, RxDouble value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Obx(
          () => Text(
            '₹${value.value.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(
    String title,
    RxDouble spent,
    RxDouble target,
    Color color,
  ) {
    return Obx(() {
      final s = spent.value;
      final t = target.value;
      final progress = t > 0 ? (s / t).clamp(0.0, 1.0) : 0.0;
      final isOverBudget = s > t && t > 0;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                  Text('₹${s.toStringAsFixed(0)} / ₹${t.toStringAsFixed(0)}'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOverBudget ? AppColors.error : color,
                ),
              ),
              if (isOverBudget)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Over budget by ₹${(s - t).toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
