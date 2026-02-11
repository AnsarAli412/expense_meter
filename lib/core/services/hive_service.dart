import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_strings.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/recurring_entry_model.dart';
import '../models/budget_config_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(SubCategoryAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(RecurringIntervalAdapter());
    Hive.registerAdapter(RecurringEntryAdapter());
    Hive.registerAdapter(BudgetConfigAdapter());

    // Open Boxes
    await Hive.openBox<User>(AppStrings.userBox);
    await Hive.openBox<Category>(AppStrings.categoriesBox);
    await Hive.openBox<Transaction>(AppStrings.transactionsBox);
    await Hive.openBox<BudgetConfig>(AppStrings.budgetBox);
    await Hive.openBox<RecurringEntry>(AppStrings.recurringBox);
    await Hive.openBox(AppStrings.settingsBox);

    await _seedCategories();
    await _seedBudgetConfig();
  }

  static Box<User> get userBox => Hive.box<User>(AppStrings.userBox);
  static Box<Category> get categoriesBox =>
      Hive.box<Category>(AppStrings.categoriesBox);
  static Box<Transaction> get transactionsBox =>
      Hive.box<Transaction>(AppStrings.transactionsBox);
  static Box<BudgetConfig> get budgetBox =>
      Hive.box<BudgetConfig>(AppStrings.budgetBox);
  static Box<RecurringEntry> get recurringBox =>
      Hive.box<RecurringEntry>(AppStrings.recurringBox);
  static Box get settingsBox => Hive.box(AppStrings.settingsBox);

  static Future<void> _seedCategories() async {
    if (categoriesBox.isEmpty) {
      const uuid = Uuid();

      // Needs
      final needs = Category(
        id: uuid.v4(),
        name: AppStrings.catNeeds,
        type: 'needs',
        subCategories: [
          SubCategory(id: uuid.v4(), name: 'Rent', parentCategoryId: ''),
          SubCategory(id: uuid.v4(), name: 'Groceries', parentCategoryId: ''),
          SubCategory(id: uuid.v4(), name: 'Utilities', parentCategoryId: ''),
          SubCategory(id: uuid.v4(), name: 'Transport', parentCategoryId: ''),
          SubCategory(id: uuid.v4(), name: 'Insurance', parentCategoryId: ''),
        ],
        colorCode: 0xFF4F58A0, // Blueish
      );
      // Update parent IDs
      for (var sub in needs.subCategories) {
        sub.parentCategoryId = needs.id;
      }

      // Wants
      final wants = Category(
        id: uuid.v4(),
        name: AppStrings.catWants,
        type: 'wants',
        subCategories: [
          SubCategory(id: uuid.v4(), name: 'Dining Out', parentCategoryId: ''),
          SubCategory(
            id: uuid.v4(),
            name: 'Entertainment',
            parentCategoryId: '',
          ),
          SubCategory(id: uuid.v4(), name: 'Shopping', parentCategoryId: ''),
          SubCategory(id: uuid.v4(), name: 'Travel', parentCategoryId: ''),
        ],
        colorCode: 0xFFB5267D, // Pinkish
      );
      for (var sub in wants.subCategories) {
        sub.parentCategoryId = wants.id;
      }

      // Savings
      final savings = Category(
        id: uuid.v4(),
        name: AppStrings.catSavings,
        type: 'savings',
        subCategories: [
          SubCategory(
            id: uuid.v4(),
            name: 'Emergency Fund',
            parentCategoryId: '',
          ),
          SubCategory(id: uuid.v4(), name: 'Investments', parentCategoryId: ''),
          SubCategory(id: uuid.v4(), name: 'Retirement', parentCategoryId: ''),
        ],
        colorCode: 0xFF006D5B, // Teal
      );
      for (var sub in savings.subCategories) {
        sub.parentCategoryId = savings.id;
      }

      await categoriesBox.add(needs);
      await categoriesBox.add(wants);
      await categoriesBox.add(savings);
    }
  }

  static Future<void> _seedBudgetConfig() async {
    if (budgetBox.isEmpty) {
      await budgetBox.add(BudgetConfig());
    }
  }

  static Future<void> clearAll() async {
    await userBox.clear();
    await categoriesBox.clear();
    await transactionsBox.clear();
    await budgetBox.clear();
    await recurringBox.clear();
    await settingsBox.clear();

    // Re-seed after clear
    await _seedCategories();
    await _seedBudgetConfig();
  }
}
