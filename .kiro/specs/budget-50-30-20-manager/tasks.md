# Implementation Plan: Budget 50/30/20 Manager

## Overview

This implementation plan breaks down the Budget 50/30/20 Manager Flutter application into discrete, incremental coding tasks. The approach follows clean architecture with feature-based organization, using GetX for state management and Hive for local data persistence. Each task builds upon previous work, ensuring no orphaned code and progressive integration.

## Tasks

- [ ] 1. Project setup and core infrastructure
  - Set up folder structure following the specified architecture
  - Configure pubspec.yaml with dependencies: GetX, Hive, fl_chart, flutter_launcher_icons
  - Create core constants files (app_constants.dart, colors.dart, strings.dart)
  - Create Material 3 theme files (app_theme.dart with light and dark themes, text_styles.dart)
  - _Requirements: 19.1, 19.2, 19.3, 12.1_

- [ ] 2. Database layer implementation
  - [ ] 2.1 Create Hive data models with type adapters
    - Implement User model (HiveType 0) with name and currency fields
    - Implement Category model (HiveType 1) with id, name, percentage, type fields
    - Implement SubCategory model (HiveType 2) with id, name, categoryId fields
    - Implement Income model (HiveType 3) with id, amount, source, month, year, date fields
    - Implement Expense model (HiveType 4) with id, amount, categoryId, subcategoryId, date, description fields
    - Implement BudgetConfig model (HiveType 5) with needsPercent, wantsPercent, savingsPercent fields
    - Implement RecurringEntry model (HiveType 6) with id, amount, type, frequency, categoryId, subcategoryId, source fields
    - Generate Hive type adapters for all models
    - _Requirements: 20.1, 20.2, 20.3, 20.4, 20.5, 20.6, 20.7_

  - [ ]* 2.2 Write property test for data model persistence
    - **Property 1: Data Persistence Round Trip**
    - **Validates: Requirements 3.3, 5.3, 9.4, 11.3, 12.2, 14.2, 14.3**

  - [ ] 2.3 Implement DatabaseService
    - Create initialize() method to open all Hive boxes and register type adapters
    - Create seedDefaultData() method to populate default categories, subcategories, and budget config
    - Create clearAllData() method for data reset functionality
    - _Requirements: 1.1, 2.4, 13.3, 20.8_

  - [ ]* 2.4 Write unit tests for DatabaseService
    - Test initialization success and failure scenarios
    - Test default data seeding
    - Test data clearing
    - _Requirements: 1.1, 1.4, 17.1_

  - [ ] 2.5 Implement StorageService for shared preferences
    - Create methods for saving/loading theme preference
    - Create methods for saving/loading onboarding completion status
    - _Requirements: 12.2, 12.4_

- [ ] 3. Utility and validation layer
  - [ ] 3.1 Create validation utilities
    - Implement amount validation (positive number check)
    - Implement required field validation (non-empty after trim)
    - Implement percentage sum validation (equals 100%)
    - _Requirements: 16.1, 16.2, 16.5, 11.2_

  - [ ]* 3.2 Write property tests for validation
    - **Property 2: Amount Validation**
    - **Property 3: Required Field Validation**
    - **Property 19: Budget Config Percentage Sum Validation**
    - **Validates: Requirements 3.2, 5.2, 16.1, 2.3, 3.1, 5.1, 8.3, 9.2, 9.3, 16.2, 16.4, 16.5, 11.2**

  - [ ] 3.2 Create utility functions
    - Implement date formatting utilities
    - Implement currency formatting utilities
    - _Requirements: 6.1, 6.2_

- [ ] 4. Repository layer implementation
  - [ ] 4.1 Implement IncomeRepository
    - Create addIncome() method
    - Create getIncomeByMonth() method with month/year filtering
    - Create getAllIncome() method
    - Create getTotalIncomeForMonth() method with aggregation
    - Create deleteIncome() method
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

  - [ ]* 4.2 Write property tests for IncomeRepository
    - **Property 5: Transaction Sorting**
    - **Property 6: Category Expense Aggregation** (for income aggregation)
    - **Validates: Requirements 3.4, 3.5**

  - [ ] 4.3 Implement ExpenseRepository
    - Create addExpense() method
    - Create getExpensesByMonth() method with month/year filtering
    - Create getAllExpenses() method
    - Create getTotalExpenseForMonth() method
    - Create getTotalExpenseByCategory() method
    - Create getExpensesBySubcategory() method for chart data
    - Create deleteExpense() method
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

  - [ ]* 4.4 Write property tests for ExpenseRepository
    - **Property 5: Transaction Sorting** (for expenses)
    - **Property 6: Category Expense Aggregation**
    - **Property 15: Expense Distribution Chart Data**
    - **Validates: Requirements 5.4, 5.5, 10.2**

  - [ ] 4.5 Implement CategoryRepository
    - Create methods for category CRUD operations
    - Create methods for subcategory CRUD operations
    - Create hasExpensesForSubCategory() method for constraint checking
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_

  - [ ]* 4.6 Write property tests for CategoryRepository
    - **Property 12: SubCategory CRUD Operations**
    - **Property 13: SubCategory Deletion Constraint**
    - **Validates: Requirements 8.2, 8.4, 8.5, 8.6**

  - [ ] 4.7 Implement RecurringRepository
    - Create addRecurringEntry() method
    - Create getAllRecurringEntries() method
    - Create updateRecurringEntry() method
    - Create deleteRecurringEntry() method
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

  - [ ]* 4.8 Write property tests for RecurringRepository
    - **Property 14: Recurring Entry Storage and Retrieval**
    - **Validates: Requirements 9.1, 9.5**

  - [ ] 4.9 Implement BudgetRepository
    - Create getBudgetConfig() method
    - Create updateBudgetConfig() method with validation
    - Create resetToDefault() method
    - _Requirements: 11.1, 11.2, 11.3, 11.5_

- [ ] 5. Checkpoint - Ensure repository tests pass
  - Ensure all repository tests pass, ask the user if questions arise.

- [ ] 6. Shared UI components
  - [ ] 6.1 Create reusable widgets
    - Implement CustomButton with loading state
    - Implement CustomTextField with validation display
    - Implement LoadingIndicator
    - Implement EmptyState widget
    - _Requirements: 19.6, 19.7_

  - [ ] 6.2 Create specialized components
    - Implement CategorySelector dropdown
    - Implement DatePickerField
    - _Requirements: 5.1_

- [ ] 7. Splash screen and initialization
  - [ ] 7.1 Implement SplashController
    - Initialize DatabaseService
    - Check onboarding completion status
    - Navigate to appropriate screen (onboarding or dashboard)
    - Handle initialization errors with retry logic
    - _Requirements: 1.1, 1.2, 1.3, 1.4_

  - [ ] 7.2 Implement SplashScreen UI
    - Display app logo and loading indicator
    - Show error messages if initialization fails
    - _Requirements: 1.1, 17.1_

  - [ ]* 7.3 Write unit tests for SplashController
    - Test navigation logic for first-time vs returning users
    - Test error handling and retry mechanism
    - _Requirements: 1.2, 1.3, 1.4_

- [ ] 8. Onboarding and profile setup
  - [ ] 8.1 Implement OnboardingController
    - Manage page navigation through 3 onboarding pages
    - Mark onboarding as complete
    - Navigate to profile setup
    - _Requirements: 2.1, 2.2_

  - [ ] 8.2 Implement OnboardingScreen UI
    - Create 3 pages explaining the 50/30/20 rule
    - Add page indicators and navigation buttons
    - _Requirements: 2.1_

  - [ ] 8.3 Implement ProfileSetupController
    - Validate name (non-empty)
    - Save user profile to database
    - Trigger database seeding
    - Navigate to dashboard
    - _Requirements: 2.2, 2.3, 2.4, 2.5_

  - [ ] 8.4 Implement ProfileSetupScreen UI
    - Create form with name and currency fields
    - Display validation errors
    - _Requirements: 2.2, 2.3_

- [ ] 9. Dashboard implementation
  - [ ] 9.1 Implement DashboardController
    - Load monthly income and calculate total
    - Load monthly expenses and calculate total
    - Calculate remaining balance
    - Load budget config and calculate category budgets
    - Calculate spending per category
    - Calculate budget usage percentages
    - Determine over-budget warnings
    - Load 5 most recent transactions
    - Implement month/year selection
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 4.1, 4.2, 4.3, 7.1, 7.2, 7.3, 7.4, 7.5_

  - [ ]* 9.2 Write property tests for DashboardController
    - **Property 4: Budget Calculation**
    - **Property 7: Balance Calculation**
    - **Property 8: Budget Usage Percentage**
    - **Property 9: Recent Transactions Filtering**
    - **Property 10: Over-Budget Warning**
    - **Property 11: Under-Budget Normal State**
    - **Validates: Requirements 4.1, 4.2, 4.3, 11.4, 6.3, 7.4, 6.5, 7.1, 6.6, 6.7, 7.3, 7.5, 7.2**

  - [ ] 9.3 Create dashboard widgets
    - Implement SummaryHeader showing income, expense, balance
    - Implement BudgetCard for each category with progress indicator
    - Implement TransactionListItem for recent transactions
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

  - [ ] 9.4 Implement DashboardScreen UI
    - Display summary header
    - Display three budget cards (Needs, Wants, Savings)
    - Display recent transactions list
    - Add floating action buttons for adding income/expense
    - Implement month/year selector
    - Show empty state when no data exists
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 19.7_

  - [ ]* 9.5 Write widget tests for dashboard components
    - Test BudgetCard rendering with different states
    - Test warning indicators
    - Test empty state display
    - _Requirements: 6.7, 19.7_

- [ ] 10. Checkpoint - Ensure dashboard functionality works
  - Ensure all dashboard tests pass, ask the user if questions arise.

- [ ] 11. Income management feature
  - [ ] 11.1 Implement IncomeController
    - Implement addIncome() with validation
    - Implement loadIncome() to fetch history
    - Implement deleteIncome()
    - Handle loading states and errors
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [ ] 11.2 Implement AddIncomeScreen UI
    - Create form with amount, source, month, year fields
    - Display validation errors inline
    - Show loading indicator during submission
    - Navigate back to dashboard on success
    - _Requirements: 3.1, 3.2, 16.3, 16.4_

  - [ ] 11.3 Implement IncomeHistoryScreen UI
    - Display list of all income entries sorted by date
    - Show empty state when no income exists
    - Implement swipe-to-delete functionality
    - _Requirements: 3.4, 19.7_

  - [ ]* 11.4 Write unit tests for IncomeController
    - Test validation logic
    - Test error handling
    - _Requirements: 3.2, 17.1_

- [ ] 12. Expense management feature
  - [ ] 12.1 Implement ExpenseController
    - Implement addExpense() with validation
    - Implement loadExpenses() to fetch history
    - Implement loadCategories() and loadSubcategoriesForCategory()
    - Implement deleteExpense()
    - Handle loading states and errors
    - _Requirements: 5.1, 5.2, 5.3, 5.4_

  - [ ] 12.2 Implement AddExpenseScreen UI
    - Create form with amount, category, subcategory, date, description fields
    - Implement category and subcategory selectors
    - Display validation errors inline
    - Show loading indicator during submission
    - Navigate back to dashboard on success
    - _Requirements: 5.1, 5.2, 16.3, 16.4_

  - [ ] 12.3 Implement ExpenseHistoryScreen UI
    - Display list of all expense entries sorted by date
    - Show category and subcategory for each expense
    - Show empty state when no expenses exist
    - Implement swipe-to-delete functionality
    - _Requirements: 5.4, 19.7_

  - [ ]* 12.4 Write unit tests for ExpenseController
    - Test validation logic
    - Test category/subcategory loading
    - Test error handling
    - _Requirements: 5.2, 17.1_

- [ ] 13. Reports and analytics feature
  - [ ] 13.1 Implement ReportsController
    - Implement loadMonthlyReport() to aggregate data
    - Implement loadYearlyReport() for 12-month overview
    - Calculate expense distribution by subcategory
    - Calculate budget comparison (actual vs ideal)
    - Implement month/year selection
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6_

  - [ ]* 13.2 Write property tests for ReportsController
    - **Property 16: Budget Comparison Calculation**
    - **Property 17: Yearly Chart Data**
    - **Property 18: Report Period Filtering**
    - **Validates: Requirements 10.3, 10.5, 10.6**

  - [ ] 13.3 Create report widgets
    - Implement PieChartWidget using fl_chart for expense distribution
    - Implement BarChartWidget using fl_chart for yearly overview
    - Implement BudgetComparisonCard showing actual vs ideal
    - _Requirements: 10.2, 10.3, 10.5_

  - [ ] 13.4 Implement ReportsScreen UI
    - Display month/year selector
    - Display monthly summary (income, expense, balance)
    - Display pie chart for expense distribution
    - Display budget comparison cards for each category
    - Display yearly overview bar chart
    - Show empty state when no data exists
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6, 19.7_

  - [ ]* 13.5 Write unit tests for chart data generation
    - Test pie chart data calculation
    - Test bar chart data calculation
    - _Requirements: 10.2, 10.5_

- [ ] 14. Recurring entries feature
  - [ ] 14.1 Implement RecurringController
    - Implement addRecurringEntry() with validation
    - Implement loadRecurringEntries()
    - Implement updateRecurringEntry()
    - Implement deleteRecurringEntry()
    - Handle loading states and errors
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

  - [ ] 14.2 Implement AddRecurringScreen UI
    - Create form with amount, type, frequency fields
    - Conditionally show category/subcategory for expenses
    - Conditionally show source for income
    - Display validation errors inline
    - _Requirements: 9.1, 9.2, 9.3_

  - [ ] 14.3 Implement RecurringScreen UI
    - Display list of all recurring entries
    - Show type, amount, frequency for each entry
    - Implement edit and delete actions
    - Show empty state when no recurring entries exist
    - _Requirements: 9.5, 19.7_

  - [ ]* 14.4 Write unit tests for RecurringController
    - Test validation logic for different entry types
    - Test conditional field requirements
    - _Requirements: 9.2, 9.3_

- [ ] 15. Category management feature
  - [ ] 15.1 Implement CategoryController
    - Implement loadCategories() and loadSubcategories()
    - Implement addSubCategory() with validation
    - Implement updateSubCategory()
    - Implement deleteSubCategory() with constraint checking
    - Handle loading states and errors
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_

  - [ ] 15.2 Implement CategoryManagementScreen UI
    - Display list of categories with their subcategories
    - Implement add subcategory dialog
    - Implement edit subcategory dialog
    - Implement delete confirmation with constraint error handling
    - Show default categories
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 17.1_

  - [ ]* 15.3 Write unit tests for CategoryController
    - Test subcategory validation
    - Test deletion constraint enforcement
    - Test error messages
    - _Requirements: 8.3, 8.6, 17.1_

- [ ] 16. Settings feature
  - [ ] 16.1 Implement SettingsController
    - Implement toggleTheme() to switch between light/dark
    - Implement updateBudgetConfig() with percentage validation
    - Implement resetBudgetConfig() to restore defaults
    - Implement resetAllData() with confirmation
    - Handle loading states and errors
    - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5, 12.1, 12.2, 12.3, 13.1, 13.2, 13.3, 13.4, 13.5_

  - [ ] 16.2 Create BudgetConfigDialog widget
    - Display three input fields for Needs, Wants, Savings percentages
    - Validate that sum equals 100%
    - Show validation errors
    - _Requirements: 11.1, 11.2, 16.3_

  - [ ] 16.3 Implement SettingsScreen UI
    - Display theme toggle switch
    - Display budget configuration section with edit button
    - Display data reset button with confirmation dialog
    - Display app info section
    - _Requirements: 11.1, 12.1, 12.3, 13.1, 13.2_

  - [ ]* 16.4 Write unit tests for SettingsController
    - Test percentage validation
    - Test theme persistence
    - Test data reset functionality
    - _Requirements: 11.2, 12.2, 13.3, 13.4_

- [ ] 17. Checkpoint - Ensure all features work together
  - Ensure all feature tests pass, ask the user if questions arise.

- [ ] 18. Navigation and routing setup
  - [ ] 18.1 Configure GetX navigation
    - Define named routes for all screens
    - Create GetX bindings for each feature
    - Configure initial route based on onboarding status
    - Implement back button handling for dashboard
    - _Requirements: 15.1, 15.2, 15.3, 15.4, 15.5_

  - [ ]* 18.2 Write property test for navigation
    - **Property 20: Navigation Stack Integrity**
    - **Validates: Requirements 15.3**

  - [ ]* 18.3 Write integration tests for navigation flows
    - Test onboarding → profile setup → dashboard flow
    - Test dashboard → add income → back to dashboard flow
    - Test dashboard → add expense → back to dashboard flow
    - Test back button behavior
    - _Requirements: 1.2, 1.3, 2.5, 15.3, 15.4_

- [ ] 19. Main app setup and integration
  - [ ] 19.1 Implement main.dart
    - Initialize Hive and DatabaseService
    - Initialize StorageService
    - Configure GetMaterialApp with routes and theme
    - Set up theme mode based on saved preference
    - Handle app lifecycle
    - _Requirements: 1.1, 12.1, 12.4, 14.1, 15.1_

  - [ ] 19.2 Wire all features together
    - Ensure all controllers are properly bound
    - Ensure all repositories are properly injected
    - Verify data flows correctly between features
    - Test that dashboard updates when income/expense is added
    - _Requirements: 14.2, 18.4_

  - [ ]* 19.3 Write integration tests for complete user flows
    - Test complete onboarding and first income/expense flow
    - Test data persistence across app restarts
    - Test theme switching persistence
    - Test data reset and recovery
    - _Requirements: 14.3, 12.2, 13.3, 13.4, 13.5_

- [ ] 20. Final polish and edge cases
  - [ ] 20.1 Handle edge cases
    - Implement zero income state (all budgets show zero)
    - Implement empty data states for all screens
    - Ensure proper error messages for all validation failures
    - Test with very large numbers
    - Test with very small decimal amounts
    - _Requirements: 4.5, 19.7, 16.3, 17.4_

  - [ ] 20.2 Performance optimization
    - Add const constructors where applicable
    - Optimize Obx widget usage to minimize rebuilds
    - Ensure database queries are efficient
    - _Requirements: 18.1, 18.2, 18.3, 18.4, 18.5_

  - [ ] 20.3 UI/UX refinements
    - Add smooth animations for screen transitions
    - Add loading indicators for async operations
    - Ensure consistent spacing and padding
    - Verify Material 3 design compliance
    - Test on different screen sizes
    - _Requirements: 19.1, 19.2, 19.3, 19.4, 19.5_

- [ ] 21. Final checkpoint - Complete testing and validation
  - Run all unit tests and ensure they pass
  - Run all property tests and ensure they pass
  - Run all integration tests and ensure they pass
  - Test the complete app flow manually
  - Verify all requirements are met
  - Ask the user if any issues or questions arise

## Notes

- Tasks marked with `*` are optional testing tasks and can be skipped for faster MVP delivery
- Each task references specific requirements for traceability
- Property tests validate universal correctness properties across all inputs
- Unit tests validate specific examples, edge cases, and error conditions
- Integration tests validate complete user flows and data persistence
- Checkpoints ensure incremental validation and provide opportunities for user feedback
- The implementation follows clean architecture with clear separation between UI, business logic, and data layers
- All data operations are offline-first using Hive local database
- GetX is used consistently for state management, dependency injection, and navigation
