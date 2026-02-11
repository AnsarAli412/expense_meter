import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/category_model.dart';
import '../../core/services/hive_service.dart';

class CategoryController extends GetxController {
  final RxList<Category> categories = <Category>[].obs;
  final TextEditingController subCategoryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = HiveService.categoriesBox.values
        .toList()
        .cast<Category>();
  }

  void addSubCategory(Category category) {
    Get.defaultDialog(
      title: 'Add Sub-Category',
      content: TextField(
        controller: subCategoryController,
        decoration: const InputDecoration(hintText: 'Enter name'),
      ),
      textConfirm: 'Add',
      textCancel: 'Cancel',
      onConfirm: () async {
        if (subCategoryController.text.isNotEmpty) {
          final sub = SubCategory(
            id: const Uuid().v4(),
            name: subCategoryController.text.trim(),
            parentCategoryId: category.id,
          );

          category.subCategories.add(sub);
          await category.save(); // HiveObject save

          subCategoryController.clear();
          loadCategories();
          Get.back();
        }
      },
    );
  }

  void deleteSubCategory(Category category, SubCategory sub) async {
    category.subCategories.remove(sub);
    await category.save();
    loadCategories();
  }
}
