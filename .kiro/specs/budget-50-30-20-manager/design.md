# Design Document: Budget 50/30/20 Manager

## Overview

The Budget 50/30/20 Manager is a Flutter mobile application implementing clean architecture with feature-based organization. The application uses GetX for state management, Hive for local data persistence, and fl_chart for data visualization. The architecture follows a clear separation between presentation (UI), business logic (controllers), and data layers (services/repositories).

The application operates entirely offline, with all data stored locally using Hive. The core business logic revolves around the 50/30/20 budgeting rule, where income is automatically allocated into three categories: 50% for Needs, 30% for Wants, and 20% for Savings. Users can track income, expenses, view budget progress, and analyze spending patterns through comprehensive reports.

## Architecture

### High-Level Architecture

The application follows Clean Architecture principles with three main layers:

1. **Presentation Layer**: Flutter widgets and GetX controllers
2. **Domain Layer**: Business logic and use cases
3. **Data Layer**: Hive database and data models

### Architectural Patterns

- **State Management**: GetX (reactive programming with Obx widgets)
- **Dependency Injection**: GetX bindings for each feature
- **Navigation**: GetX named routes with proper bindings
- **Database**: Hive (NoSQL local storage with type adapters)

### Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart          # App-wide constants
│   │   ├── colors.dart                 # Color definitions
│   │   └── strings.dart                # String constants
│   ├── utils/
│   │   ├── date_utils.dart             # Date formatting utilities
│   │   ├── currency_formatter.dart     # Currency formatting
│   │   └── validators.dart             # Input validation
│   ├── theme/
│   │   ├── app_theme.dart              # Light/Dark theme definitions
│   │   └── text_styles.dart            # Typography styles
│   ├── services/
│   │   ├── database_service.dart       # Hive initialization
│   │   └── storage_service.dart        # Shared preferences wrapper
│   └── database/
│       ├── hive_boxes.dart             # Box name constants
│       └── type_adapters/              # Hive type adapters
├── features/
│   ├── splash/
│   │   ├── splash_screen.dart
│   │   └── splash_controller.dart
│   ├── onboarding/
│   │   ├── onboarding_screen.dart
│   │   └── onboarding_controller.dart
│   ├── profile_setup/
│   │   ├── profile_setup_screen.dart
│   │   └── profile_setup_controller.dart
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   ├── dashboard_controller.dart
│   │   └── widgets/
│   │       ├── budget_card.dart
│   │       ├── transaction_list_item.dart
│   │       └── summary_header.dart
│   ├── income/
│   │   ├── add_income_screen.dart
│   │   ├── income_history_screen.dart
│   │   ├── income_controller.dart
│   │   └── income_repository.dart
│   ├── expense/
│   │   ├── add_expense_screen.dart
│   │   ├── expense_history_screen.dart
│   │   ├── expense_controller.dart
│   │   └── expense_repository.dart
│   ├── reports/
│   │   ├── reports_screen.dart
│   │   ├── reports_controller.dart
│   │   └── widgets/
│   │       ├── pie_chart_widget.dart
│   │       ├── bar_chart_widget.dart
│   │       └── budget_comparison_card.dart
│   ├── recurring/
│   │   ├── recurring_screen.dart
│   │   ├── add_recurring_screen.dart
│   │   ├── recurring_controller.dart
│   │   └── recurring_repository.dart
│   ├── settings/
│   │   ├── settings_screen.dart
│   │   ├── settings_controller.dart
│   │   └── widgets/
│   │       └── budget_config_dialog.dart
│   └── category/
│       ├── category_management_screen.dart
│       ├── category_controller.dart
│       └── category_repository.dart
├── shared/
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   └── empty_state.dart
│   └── components/
│       ├── category_selector.dart
│       └── date_picker_field.dart
└── main.dart
```

## Components and Interfaces

### Core Services

#### DatabaseService

Responsible for initializing Hive and registering type adapters.

```dart
class DatabaseService {
  Future<void> initialize();
  Future<void> seedDefaultData();
  Future<void> clearAllData();
}
```

**Methods:**
- `initialize()`: Opens all Hive boxes and registers type adapters
- `seedDefaultData()`: Creates default categories and subcategories on first launch
- `clearAllData()`: Deletes all data from all boxes (used in reset)

#### StorageService

Wrapper for shared preferences to store simple key-value pairs.

```dart
class StorageService {
  Future<void> saveThemeMode(bool isDark);
  bool getThemeMode();
  Future<void> saveOnboardingComplete(bool complete);
  bool isOnboardingComplete();
}
```

### Data Models

#### User Model

```dart
class User {
  String name;
  String currency;
  
  User({required this.name, required this.currency});
}
```

**Hive Type ID**: 0

#### Category Model

```dart
class Category {
  String id;
  String name;
  double percentage;
  CategoryType type;
  
  Category({
    required this.id,
    required this.name,
    required this.percentage,
    required this.type,
  });
}

enum CategoryType { needs, wants, savings }
```

**Hive Type ID**: 1

**Default Categories:**
- Needs: 50%
- Wants: 30%
- Savings: 20%

#### SubCategory Model

```dart
class SubCategory {
  String id;
  String name;
  String categoryId;
  
  SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
  });
}
```

**Hive Type ID**: 2

**Default SubCategories:**
- Needs: Rent, Utilities, Groceries, Transportation, Insurance
- Wants: Entertainment, Dining Out, Shopping, Hobbies, Subscriptions
- Savings: Emergency Fund, Investments, Retirement, Debt Payment

#### Income Model

```dart
class Income {
  String id;
  double amount;
  String source;
  int month;
  int year;
  DateTime date;
  
  Income({
    required this.id,
    required this.amount,
    required this.source,
    required this.month,
    required this.year,
    required this.date,
  });
}
```

**Hive Type ID**: 3

#### Expense Model

```dart
class Expense {
  String id;
  double amount;
  String categoryId;
  String subcategoryId;
  DateTime date;
  String description;
  
  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.subcategoryId,
    required this.date,
    required this.description,
  });
}
```

**Hive Type ID**: 4

#### BudgetConfig Model

```dart
class BudgetConfig {
  double needsPercent;
  double wantsPercent;
  double savingsPercent;
  
  BudgetConfig({
    required this.needsPercent,
    required this.wantsPercent,
    required this.savingsPercent,
  });
}
```

**Hive Type ID**: 5

#### RecurringEntry Model

```dart
class RecurringEntry {
  String id;
  double amount;
  EntryType type;
  Frequency frequency;
  String? categoryId;
  String? subcategoryId;
  String? source;
  
  RecurringEntry({
    required this.id,
    required this.amount,
    required this.type,
    required this.frequency,
    this.categoryId,
    this.subcategoryId,
    this.source,
  });
}

enum EntryType { income, expense }
enum Frequency { monthly, yearly }
```

**Hive Type ID**: 6

### Repositories

Repositories handle data access and business logic for specific domains.

#### IncomeRepository

```dart
class IncomeRepository {
  Future<void> addIncome(Income income);
  Future<List<Income>> getIncomeByMonth(int month, int year);
  Future<List<Income>> getAllIncome();
  Future<double> getTotalIncomeForMonth(int month, int year);
  Future<void> deleteIncome(String id);
}
```

#### ExpenseRepository

```dart
class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<List<Expense>> getExpensesByMonth(int month, int year);
  Future<List<Expense>> getAllExpenses();
  Future<double> getTotalExpenseForMonth(int month, int year);
  Future<double> getTotalExpenseByCategory(String categoryId, int month, int year);
  Future<Map<String, double>> getExpensesBySubcategory(int month, int year);
  Future<void> deleteExpense(String id);
}
```

#### CategoryRepository

```dart
class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
  Future<void> updateCategory(Category category);
  
  Future<void> addSubCategory(SubCategory subCategory);
  Future<List<SubCategory>> getSubCategoriesByCategory(String categoryId);
  Future<List<SubCategory>> getAllSubCategories();
  Future<void> updateSubCategory(SubCategory subCategory);
  Future<void> deleteSubCategory(String id);
  Future<bool> hasExpensesForSubCategory(String subcategoryId);
}
```

#### RecurringRepository

```dart
class RecurringRepository {
  Future<void> addRecurringEntry(RecurringEntry entry);
  Future<List<RecurringEntry>> getAllRecurringEntries();
  Future<void> updateRecurringEntry(RecurringEntry entry);
  Future<void> deleteRecurringEntry(String id);
}
```

#### BudgetRepository

```dart
class BudgetRepository {
  Future<BudgetConfig> getBudgetConfig();
  Future<void> updateBudgetConfig(BudgetConfig config);
  Future<void> resetToDefault();
}
```

### Controllers

Controllers manage state and business logic for each feature using GetX.

#### DashboardController

```dart
class DashboardController extends GetxController {
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;
  final CategoryRepository categoryRepository;
  final BudgetRepository budgetRepository;
  
  Rx<int> selectedMonth;
  Rx<int> selectedYear;
  Rx<double> totalIncome;
  Rx<double> totalExpense;
  Rx<double> remainingBalance;
  RxList<Expense> recentTransactions;
  RxMap<String, BudgetCategoryData> budgetData;
  
  @override
  void onInit();
  Future<void> loadDashboardData();
  Future<void> calculateBudgets();
  void changeMonth(int month, int year);
}

class BudgetCategoryData {
  String categoryName;
  double budgetAmount;
  double spentAmount;
  double percentage;
  bool isOverBudget;
}
```

**Key Methods:**
- `loadDashboardData()`: Fetches income, expenses, and calculates all dashboard metrics
- `calculateBudgets()`: Computes budget allocations based on income and config
- `changeMonth()`: Updates selected month/year and reloads data

#### IncomeController

```dart
class IncomeController extends GetxController {
  final IncomeRepository repository;
  
  RxList<Income> incomeList;
  Rx<bool> isLoading;
  
  Future<void> addIncome(double amount, String source, int month, int year);
  Future<void> loadIncome();
  Future<void> deleteIncome(String id);
  bool validateAmount(String amount);
  bool validateSource(String source);
}
```

#### ExpenseController

```dart
class ExpenseController extends GetxController {
  final ExpenseRepository repository;
  final CategoryRepository categoryRepository;
  
  RxList<Expense> expenseList;
  RxList<Category> categories;
  RxList<SubCategory> subcategories;
  Rx<bool> isLoading;
  
  Future<void> addExpense(double amount, String categoryId, String subcategoryId, DateTime date, String description);
  Future<void> loadExpenses();
  Future<void> loadCategories();
  Future<void> loadSubcategoriesForCategory(String categoryId);
  Future<void> deleteExpense(String id);
  bool validateAmount(String amount);
}
```

#### ReportsController

```dart
class ReportsController extends GetxController {
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;
  final BudgetRepository budgetRepository;
  final CategoryRepository categoryRepository;
  
  Rx<int> selectedMonth;
  Rx<int> selectedYear;
  Rx<double> totalIncome;
  Rx<double> totalExpense;
  RxMap<String, double> expenseBySubcategory;
  RxMap<String, BudgetComparison> budgetComparison;
  RxList<MonthlyData> yearlyData;
  
  Future<void> loadMonthlyReport();
  Future<void> loadYearlyReport();
  void changeMonth(int month, int year);
}

class BudgetComparison {
  String categoryName;
  double ideal;
  double actual;
  double difference;
  bool isOverBudget;
}

class MonthlyData {
  int month;
  double income;
  double expense;
}
```

#### SettingsController

```dart
class SettingsController extends GetxController {
  final BudgetRepository budgetRepository;
  final StorageService storageService;
  final DatabaseService databaseService;
  
  Rx<bool> isDarkMode;
  Rx<BudgetConfig> budgetConfig;
  
  Future<void> toggleTheme();
  Future<void> updateBudgetConfig(double needs, double wants, double savings);
  Future<void> resetBudgetConfig();
  Future<void> resetAllData();
  bool validatePercentages(double needs, double wants, double savings);
}
```

### UI Components

#### Custom Widgets

**CustomButton**
```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  
  // Rounded button with loading state
}
```

**CustomTextField**
```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  
  // Material 3 styled text field with validation
}
```

**BudgetCard**
```dart
class BudgetCard extends StatelessWidget {
  final String categoryName;
  final double budgetAmount;
  final double spentAmount;
  final double percentage;
  final bool isOverBudget;
  final Color color;
  
  // Displays category budget with progress indicator
}
```

**EmptyState**
```dart
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  
  // Shows when no data is available
}
```

## Data Models

### Hive Box Structure

The application uses the following Hive boxes:

- **userBox**: Stores single User instance
- **categoryBox**: Stores Category instances
- **subcategoryBox**: Stores SubCategory instances
- **incomeBox**: Stores Income instances
- **expenseBox**: Stores Expense instances
- **budgetConfigBox**: Stores single BudgetConfig instance
- **recurringBox**: Stores RecurringEntry instances

### Data Relationships

```
Category (1) ----< (N) SubCategory
Category (1) ----< (N) Expense
SubCategory (1) ----< (N) Expense
RecurringEntry (0..1) ----< (1) Category
RecurringEntry (0..1) ----< (1) SubCategory
```

### Data Flow

1. **Adding Income:**
   - User inputs amount and source
   - Controller validates input
   - Repository creates Income with generated ID and current date
   - Income saved to Hive incomeBox
   - Dashboard refreshes to show updated budget

2. **Adding Expense:**
   - User selects category, subcategory, date, and enters amount
   - Controller validates input
   - Repository creates Expense with generated ID
   - Expense saved to Hive expenseBox
   - Dashboard refreshes to show updated spending

3. **Budget Calculation:**
   - Dashboard loads total income for selected month
   - Dashboard loads budget config percentages
   - For each category: budgetAmount = totalIncome × percentage
   - Dashboard loads total expenses per category
   - Progress calculated: (spent / budget) × 100

4. **Report Generation:**
   - Reports controller loads income and expenses for selected period
   - Aggregates expenses by subcategory
   - Compares actual spending vs ideal allocations
   - Generates chart data for visualization

### Database Seeding

On first launch, the application seeds the database with:

**Default Categories:**
```dart
[
  Category(id: 'needs', name: 'Needs', percentage: 0.5, type: CategoryType.needs),
  Category(id: 'wants', name: 'Wants', percentage: 0.3, type: CategoryType.wants),
  Category(id: 'savings', name: 'Savings', percentage: 0.2, type: CategoryType.savings),
]
```

**Default SubCategories:**
```dart
// Needs
['Rent', 'Utilities', 'Groceries', 'Transportation', 'Insurance']

// Wants
['Entertainment', 'Dining Out', 'Shopping', 'Hobbies', 'Subscriptions']

// Savings
['Emergency Fund', 'Investments', 'Retirement', 'Debt Payment']
```

**Default BudgetConfig:**
```dart
BudgetConfig(needsPercent: 0.5, wantsPercent: 0.3, savingsPercent: 0.2)
```


## Correctness Properties

A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.

### Property 1: Data Persistence Round Trip

*For any* valid data object (Income, Expense, RecurringEntry, BudgetConfig, User, Category, SubCategory), after storing it in the database and then retrieving it, the retrieved object should be equivalent to the original object.

**Validates: Requirements 3.3, 5.3, 9.4, 11.3, 12.2, 14.2, 14.3**

### Property 2: Amount Validation

*For any* amount input (for Income, Expense, or RecurringEntry), if the amount is less than or equal to zero or is not a valid number, validation should fail and prevent submission.

**Validates: Requirements 3.2, 5.2, 16.1**

### Property 3: Required Field Validation

*For any* form submission with required fields, if any required field is empty or contains only whitespace after trimming, validation should fail and prevent submission.

**Validates: Requirements 2.3, 3.1, 5.1, 8.3, 9.2, 9.3, 16.2, 16.4, 16.5**

### Property 4: Budget Calculation

*For any* monthly income amount and budget configuration percentages, the calculated budget for each category (Needs, Wants, Savings) should equal the income multiplied by that category's percentage.

**Validates: Requirements 4.1, 4.2, 4.3, 11.4**

### Property 5: Transaction Sorting

*For any* list of transactions (Income or Expense), when displayed in history view, the list should be sorted by date in descending order (most recent first).

**Validates: Requirements 3.4, 5.4**

### Property 6: Category Expense Aggregation

*For any* set of expenses within a specific category and month/year period, the total expenses for that category should equal the sum of all expense amounts in that category for that period.

**Validates: Requirements 3.5, 5.5**

### Property 7: Balance Calculation

*For any* total income and total expense amounts for a given period, the remaining balance should equal total income minus total expense.

**Validates: Requirements 6.3, 7.4**

### Property 8: Budget Usage Percentage

*For any* actual spending amount and budget amount for a category, the budget usage percentage should equal (actual spending / budget amount) × 100.

**Validates: Requirements 6.5, 7.1**

### Property 9: Recent Transactions Filtering

*For any* list of transactions, when displaying recent transactions on the dashboard, the result should contain at most the 5 most recent transactions sorted by date in descending order.

**Validates: Requirements 6.6**

### Property 10: Over-Budget Warning

*For any* category where actual spending is greater than or equal to the budget amount, a warning indicator should be displayed.

**Validates: Requirements 6.7, 7.3, 7.5**

### Property 11: Under-Budget Normal State

*For any* category where actual spending is less than the budget amount, the progress indicator should be displayed in a normal (non-warning) state.

**Validates: Requirements 7.2**

### Property 12: SubCategory CRUD Operations

*For any* valid subcategory, after adding it to the database, it should be retrievable; after updating its name, the new name should be persisted; after deleting it (when it has no associated expenses), it should no longer be retrievable.

**Validates: Requirements 8.2, 8.4, 8.5**

### Property 13: SubCategory Deletion Constraint

*For any* subcategory that has one or more associated expense entries, attempting to delete it should fail and return an error.

**Validates: Requirements 8.6**

### Property 14: Recurring Entry Storage and Retrieval

*For any* valid recurring entry (income or expense), after storing it in the database, it should appear in the list of all recurring entries.

**Validates: Requirements 9.1, 9.5**

### Property 15: Expense Distribution Chart Data

*For any* set of expenses in a given month, the pie chart data should accurately represent the proportion of spending in each subcategory, where each subcategory's percentage equals (subcategory total / overall total) × 100.

**Validates: Requirements 10.2**

### Property 16: Budget Comparison Calculation

*For any* actual spending amount and ideal budget allocation for a category, the comparison should show the difference as (actual - ideal), correctly indicating over-budget (positive difference) or under-budget (negative difference).

**Validates: Requirements 10.3**

### Property 17: Yearly Chart Data

*For any* set of income and expense data across multiple months in a year, the yearly overview chart data should accurately represent each month's total income and total expense.

**Validates: Requirements 10.5**

### Property 18: Report Period Filtering

*For any* selected month and year, all report data (totals, charts, comparisons) should include only transactions from that specific month and year.

**Validates: Requirements 10.6**

### Property 19: Budget Config Percentage Sum Validation

*For any* set of three percentage values for Needs, Wants, and Savings, if their sum does not equal 100% (within a small tolerance for floating-point precision), validation should fail.

**Validates: Requirements 11.2**

### Property 20: Navigation Stack Integrity

*For any* sequence of navigation actions, the back button should navigate to the previous screen in the stack, maintaining proper navigation history.

**Validates: Requirements 15.3**

### Property 21: Validation Error Display

*For any* validation failure, an error message should be displayed to the user indicating the specific validation issue.

**Validates: Requirements 16.3**

## Error Handling

### Error Categories

The application handles the following error categories:

1. **Database Errors**
   - Initialization failures
   - Read/write operation failures
   - Data corruption

2. **Validation Errors**
   - Invalid input formats
   - Missing required fields
   - Business rule violations (e.g., percentages not summing to 100%)

3. **Constraint Violations**
   - Attempting to delete subcategories with associated expenses
   - Invalid foreign key references

### Error Handling Strategy

**Database Errors:**
- Display user-friendly error messages
- Provide retry mechanism for initialization failures
- Log detailed error information for debugging
- Gracefully degrade functionality when possible

**Validation Errors:**
- Display inline error messages on form fields
- Prevent form submission until errors are resolved
- Provide clear guidance on how to fix the error
- Highlight invalid fields visually

**Constraint Violations:**
- Display modal dialogs explaining the constraint
- Suggest alternative actions (e.g., "Delete expenses first")
- Prevent the invalid operation from executing

**Error Recovery:**
- Never leave the application in an invalid state
- Preserve user input when validation fails
- Provide clear paths to recover from errors
- Log errors for debugging without exposing technical details to users

### Error Message Examples

```dart
// Validation errors
"Amount must be greater than zero"
"Name cannot be empty"
"Percentages must sum to 100%"

// Constraint violations
"Cannot delete subcategory: 5 expenses are using it"
"Please select a category"

// Database errors
"Failed to save data. Please try again."
"Unable to initialize database. Retrying..."
```

## Testing Strategy

### Dual Testing Approach

The application requires both unit testing and property-based testing for comprehensive coverage:

**Unit Tests:**
- Specific examples demonstrating correct behavior
- Edge cases (e.g., zero income, empty data sets)
- Error conditions (e.g., database failures, invalid inputs)
- Integration points between components
- UI widget rendering and interactions

**Property-Based Tests:**
- Universal properties that hold for all inputs
- Comprehensive input coverage through randomization
- Validation logic across all possible inputs
- Calculation correctness across wide ranges
- Data persistence and retrieval integrity

### Property-Based Testing Configuration

**Framework:** Use the appropriate property-based testing library for Dart/Flutter (e.g., `test` package with custom generators or `faker` for data generation)

**Test Configuration:**
- Minimum 100 iterations per property test
- Each property test must reference its design document property
- Tag format: `// Feature: budget-50-30-20-manager, Property {number}: {property_text}`

**Example Property Test Structure:**

```dart
// Feature: budget-50-30-20-manager, Property 4: Budget Calculation
test('budget calculation property', () {
  for (int i = 0; i < 100; i++) {
    // Generate random income and percentages
    final income = randomDouble(min: 0.01, max: 100000);
    final needsPercent = randomDouble(min: 0, max: 1);
    final wantsPercent = randomDouble(min: 0, max: 1 - needsPercent);
    final savingsPercent = 1 - needsPercent - wantsPercent;
    
    // Calculate budgets
    final needsBudget = income * needsPercent;
    final wantsBudget = income * wantsPercent;
    final savingsBudget = income * savingsPercent;
    
    // Verify calculations
    expect(needsBudget, equals(income * needsPercent));
    expect(wantsBudget, equals(income * wantsPercent));
    expect(savingsBudget, equals(income * savingsPercent));
  }
});
```

### Unit Testing Focus Areas

**Repository Tests:**
- CRUD operations for each model
- Query filtering by month/year
- Aggregation calculations
- Constraint enforcement

**Controller Tests:**
- State management and reactivity
- Input validation
- Business logic execution
- Error handling

**Widget Tests:**
- UI rendering with different data states
- User interactions (button clicks, form submissions)
- Navigation flows
- Empty states and error displays

**Integration Tests:**
- Complete user flows (onboarding → profile setup → dashboard)
- Data persistence across app restarts
- Theme switching
- Data reset functionality

### Test Coverage Goals

- **Unit Test Coverage:** Minimum 80% code coverage
- **Property Test Coverage:** All 21 correctness properties implemented
- **Integration Test Coverage:** All critical user flows tested
- **Widget Test Coverage:** All custom widgets and screens tested

### Testing Best Practices

1. **Isolation:** Each test should be independent and not rely on other tests
2. **Cleanup:** Reset database state between tests
3. **Mocking:** Mock external dependencies (though minimal in this offline app)
4. **Readability:** Use descriptive test names and clear assertions
5. **Speed:** Keep unit tests fast; use integration tests for slower scenarios
6. **Maintainability:** Keep tests simple and focused on one behavior

### Continuous Testing

- Run unit tests on every code change
- Run property tests before commits
- Run integration tests before releases
- Monitor test execution time and optimize slow tests
- Maintain test documentation alongside code
