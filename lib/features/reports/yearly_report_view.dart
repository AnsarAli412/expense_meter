import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'yearly_report_controller.dart';
import '../../core/constants/app_colors.dart';

class YearlyReportView extends GetView<YearlyReportController> {
  const YearlyReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yearly Overview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.prevYear,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Obx(
                  () => Text(
                    '${controller.selectedYear.value}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: controller.nextYear,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 300,
              child: Obx(() {
                if (controller.monthlyBars.isEmpty &&
                    controller.totalIncome.value == 0 &&
                    controller.totalExpense.value == 0) {
                  return const Center(child: Text('No data for this year'));
                }
                return BarChart(
                  BarChartData(
                    barGroups: controller.monthlyBars,
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = [
                              'J',
                              'F',
                              'M',
                              'A',
                              'M',
                              'J',
                              'J',
                              'A',
                              'S',
                              'O',
                              'N',
                              'D',
                            ];
                            if (value.toInt() >= 1 && value.toInt() <= 12) {
                              return Text(
                                months[value.toInt() - 1],
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Income'),
                        Obx(
                          () => Text(
                            '₹${controller.totalIncome.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.income,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Expense'),
                        Obx(
                          () => Text(
                            '₹${controller.totalExpense.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.expense,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Net Savings'),
                        Obx(
                          () => Text(
                            '₹${(controller.totalIncome.value - controller.totalExpense.value).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
