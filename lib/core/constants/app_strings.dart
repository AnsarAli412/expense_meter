class AppStrings {
  static const String appName = 'Expense Meter';
  static const String currencySymbol = '₹'; // Default, can be user changed

  // Hive Boxes
  static const String userBox = 'user_box';
  static const String categoriesBox = 'categories_box';
  static const String transactionsBox =
      'transactions_box'; // Unified or separate
  static const String incomeBox = 'income_box'; // If separating
  static const String expenseBox = 'expense_box'; // If separating
  static const String budgetBox = 'budget_box';
  static const String recurringBox = 'recurring_box';
  static const String settingsBox = 'settings_box';

  // Categories
  static const String catNeeds = 'Needs';
  static const String catWants = 'Wants';
  static const String catSavings = 'Savings';
}
