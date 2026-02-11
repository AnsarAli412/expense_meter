import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../routes/app_routes.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Configuration',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              'Needs',
              controller.needsPercent,
              AppColors.needsColor,
            ),
            _buildSlider('Wants', controller.wantsPercent, AppColors.tertiary),
            _buildSlider(
              'Savings',
              controller.savingsPercent,
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: controller.updatePercentages,
                child: const Text('Save Configuration'),
              ),
            ),
            const Divider(height: 48),

            Text(
              'App Settings',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Manage Categories'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.toNamed(Routes.CATEGORY_MANAGEMENT),
            ),

            Obx(
              () => SwitchListTile(
                title: const Text('Dark Mode'),
                secondary: const Icon(Icons.dark_mode),
                value: controller.isDarkMode.value,
                onChanged: controller.toggleTheme,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.delete_forever, color: AppColors.error),
              title: const Text(
                'Reset All Data',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: controller.resetData,
            ),

            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Budget 50/30/20 Manager v1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, RxDouble value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            Obx(() => Text('${value.value.toStringAsFixed(0)}%')),
          ],
        ),
        Obx(
          () => Slider(
            value: value.value,
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: color,
            onChanged: (val) => value.value = val,
          ),
        ),
      ],
    );
  }
}
