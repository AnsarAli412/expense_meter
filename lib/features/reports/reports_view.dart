import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.prevMonth,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Obx(
                  () => Text(
                    DateFormat.yMMMM().format(controller.currentMonth.value),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: controller.nextMonth,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pie Chart
            SizedBox(
              height: 250,
              child: Obx(() {
                if (controller.pieChartSections.isEmpty) {
                  return const Center(child: Text('No expenses this month'));
                }
                return PieChart(
                  PieChartData(
                    sections: controller.pieChartSections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Breakdown List
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.categorySpending.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = controller.categorySpending[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(item.category.colorCode),
                      child: Text(
                        item.category.name[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(item.category.name),
                    subtitle: Text(item.category.type.toUpperCase()),
                    trailing: Text(
                      '₹${item.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
