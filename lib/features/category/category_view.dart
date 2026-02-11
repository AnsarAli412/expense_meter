import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_controller.dart';
import '../../core/constants/app_colors.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Color(category.colorCode),
                  child: Text(
                    category.name[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(category.name),
                subtitle: Text(
                  '${category.subCategories.length} sub-categories',
                ),
                children: [
                  ...category.subCategories.map(
                    (sub) => ListTile(
                      title: Text(sub.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        onPressed: () =>
                            controller.deleteSubCategory(category, sub),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add Sub-Category'),
                    onTap: () => controller.addSubCategory(category),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
