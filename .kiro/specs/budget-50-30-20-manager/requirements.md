# Requirements Document: Budget 50/30/20 Manager

## Introduction

The Budget 50/30/20 Manager is a mobile-first personal finance application that helps users manage their finances using the 50/30/20 budgeting rule. The application operates entirely offline with local data storage, providing users with income tracking, expense categorization, budget monitoring, and financial reporting capabilities. The 50/30/20 rule allocates 50% of income to Needs, 30% to Wants, and 20% to Savings.

## Glossary

- **Application**: The Budget 50/30/20 Manager Flutter mobile application
- **User**: The person using the application to manage their personal finances
- **Income**: Money received by the User from various sources
- **Expense**: Money spent by the User, categorized as Needs, Wants, or Savings
- **Category**: A top-level classification (Needs, Wants, or Savings) with an associated budget percentage
- **SubCategory**: A specific classification within a Category (e.g., "Rent" under Needs)
- **Budget_Rule**: The 50/30/20 allocation principle (50% Needs, 30% Wants, 20% Savings)
- **Monthly_Budget**: The calculated budget amounts for each Category based on monthly Income
- **Database**: The local Hive database storing all application data
- **Recurring_Entry**: An Income or Expense that repeats at regular intervals
- **Dashboard**: The main screen displaying budget overview and recent transactions
- **Theme**: The visual appearance mode (Light or Dark)
- **Budget_Config**: User-customizable percentages for each Category

## Requirements

### Requirement 1: Application Initialization

**User Story:** As a new user, I want the application to initialize properly on first launch, so that I can start using it immediately without errors.

#### Acceptance Criteria

1. WHEN the Application starts, THE Application SHALL initialize the Database before displaying any UI
2. WHEN Database initialization completes successfully, THE Application SHALL navigate to the onboarding screen for first-time users
3. WHEN Database initialization completes successfully and the User has completed onboarding, THE Application SHALL navigate to the Dashboard
4. IF Database initialization fails, THEN THE Application SHALL display an error message and retry initialization

### Requirement 2: User Onboarding

**User Story:** As a new user, I want to learn about the 50/30/20 budgeting rule and set up my profile, so that I understand how to use the application effectively.

#### Acceptance Criteria

1. THE Application SHALL display a 3-page onboarding flow explaining the Budget_Rule
2. WHEN the User completes onboarding, THE Application SHALL prompt for profile setup (name and currency)
3. WHEN the User submits profile information, THE Application SHALL validate that the name is non-empty
4. WHEN profile setup completes, THE Application SHALL seed the Database with default Categories and SubCategories
5. WHEN profile setup completes, THE Application SHALL navigate to the Dashboard

### Requirement 3: Income Management

**User Story:** As a user, I want to add and track my income, so that the application can calculate my budget allocations.

#### Acceptance Criteria

1. WHEN the User adds Income, THE Application SHALL require amount, source, month, and year
2. WHEN the User submits Income, THE Application SHALL validate that the amount is greater than zero
3. WHEN valid Income is submitted, THE Application SHALL store it in the Database with the current date
4. WHEN the User views income history, THE Application SHALL display all Income entries sorted by date in descending order
5. THE Application SHALL calculate total monthly Income by summing all Income entries for the selected month and year

### Requirement 4: Budget Calculation

**User Story:** As a user, I want the application to automatically calculate my budget allocations, so that I know how much I can spend in each category.

#### Acceptance Criteria

1. WHEN monthly Income exists, THE Application SHALL calculate Monthly_Budget for Needs as Income multiplied by Budget_Config needs percentage
2. WHEN monthly Income exists, THE Application SHALL calculate Monthly_Budget for Wants as Income multiplied by Budget_Config wants percentage
3. WHEN monthly Income exists, THE Application SHALL calculate Monthly_Budget for Savings as Income multiplied by Budget_Config savings percentage
4. WHEN Budget_Config percentages are modified, THE Application SHALL recalculate all Monthly_Budget amounts immediately
5. WHEN no Income exists for a month, THE Application SHALL display zero for all Monthly_Budget amounts

### Requirement 5: Expense Management

**User Story:** As a user, I want to add and categorize my expenses, so that I can track my spending against my budget.

#### Acceptance Criteria

1. WHEN the User adds an Expense, THE Application SHALL require amount, Category, SubCategory, and date
2. WHEN the User submits an Expense, THE Application SHALL validate that the amount is greater than zero
3. WHEN valid Expense is submitted, THE Application SHALL store it in the Database with the selected date
4. WHEN the User views expense history, THE Application SHALL display all Expense entries sorted by date in descending order
5. THE Application SHALL calculate total expenses per Category by summing all Expense entries for that Category in the selected month

### Requirement 6: Dashboard Display

**User Story:** As a user, I want to see an overview of my budget status, so that I can quickly understand my financial situation.

#### Acceptance Criteria

1. THE Dashboard SHALL display total monthly Income for the current month
2. THE Dashboard SHALL display total Expense amount for the current month
3. THE Dashboard SHALL display remaining balance calculated as total Income minus total Expense
4. THE Dashboard SHALL display three budget cards showing Needs, Wants, and Savings with their respective Monthly_Budget amounts and actual spending
5. THE Dashboard SHALL display progress indicators for each Category showing percentage of budget used
6. THE Dashboard SHALL display the 5 most recent transactions sorted by date in descending order
7. WHEN a Category budget is exceeded, THE Dashboard SHALL display a warning indicator on that Category card

### Requirement 7: Budget Progress Tracking

**User Story:** As a user, I want to see how much of my budget I've used in each category, so that I can avoid overspending.

#### Acceptance Criteria

1. THE Application SHALL calculate budget usage percentage as (actual spending / Monthly_Budget) × 100 for each Category
2. WHEN actual spending is less than Monthly_Budget, THE Application SHALL display the progress indicator in a normal state
3. WHEN actual spending equals or exceeds Monthly_Budget, THE Application SHALL display the progress indicator in a warning state
4. THE Application SHALL display remaining budget amount as Monthly_Budget minus actual spending for each Category
5. WHEN remaining budget is negative, THE Application SHALL display the amount as over budget

### Requirement 8: Category Management

**User Story:** As a user, I want to manage categories and subcategories, so that I can customize expense classification to match my needs.

#### Acceptance Criteria

1. THE Application SHALL provide default Categories: Needs (50%), Wants (30%), and Savings (20%)
2. THE Application SHALL allow the User to add new SubCategories to existing Categories
3. WHEN the User adds a SubCategory, THE Application SHALL require a non-empty name and valid Category association
4. THE Application SHALL allow the User to edit SubCategory names
5. THE Application SHALL allow the User to delete SubCategories that have no associated Expense entries
6. WHEN the User attempts to delete a SubCategory with associated Expenses, THE Application SHALL prevent deletion and display an error message

### Requirement 9: Recurring Entries

**User Story:** As a user, I want to set up recurring income and expenses, so that I don't have to manually enter regular transactions.

#### Acceptance Criteria

1. THE Application SHALL allow the User to create Recurring_Entry for both Income and Expense
2. WHEN creating a Recurring_Entry, THE Application SHALL require amount, type (Income or Expense), and frequency (monthly or yearly)
3. WHEN creating a recurring Expense, THE Application SHALL require Category and SubCategory selection
4. THE Application SHALL store Recurring_Entry definitions in the Database
5. THE Application SHALL display all active Recurring_Entry items in a dedicated view

### Requirement 10: Financial Reporting

**User Story:** As a user, I want to view detailed reports of my spending patterns, so that I can make informed financial decisions.

#### Acceptance Criteria

1. THE Application SHALL generate a monthly report showing total Income, total Expense, and remaining balance
2. THE Application SHALL display a pie chart showing expense distribution across all SubCategories for the selected month
3. THE Application SHALL display a comparison between actual spending and ideal Budget_Rule allocations for each Category
4. THE Application SHALL display over-budget or under-budget indicators for each Category
5. THE Application SHALL generate a yearly overview showing monthly Income and Expense trends in a line or bar chart
6. WHEN the User selects a different month or year, THE Application SHALL update all reports to reflect the selected period

### Requirement 11: Budget Configuration

**User Story:** As a user, I want to customize my budget percentages, so that I can adapt the budgeting rule to my personal financial situation.

#### Acceptance Criteria

1. THE Application SHALL allow the User to modify Budget_Config percentages for Needs, Wants, and Savings
2. WHEN the User modifies percentages, THE Application SHALL validate that the sum equals 100%
3. WHEN the User submits valid percentages, THE Application SHALL update Budget_Config in the Database
4. WHEN Budget_Config is updated, THE Application SHALL recalculate all Monthly_Budget amounts using the new percentages
5. THE Application SHALL provide a reset option to restore default percentages (50/30/20)

### Requirement 12: Theme Management

**User Story:** As a user, I want to switch between light and dark themes, so that I can use the application comfortably in different lighting conditions.

#### Acceptance Criteria

1. THE Application SHALL support both Light and Dark Theme modes
2. THE Application SHALL persist the User's Theme preference in the Database
3. WHEN the User toggles Theme, THE Application SHALL apply the new Theme immediately without restarting
4. WHEN the Application starts, THE Application SHALL load and apply the User's saved Theme preference

### Requirement 13: Data Management

**User Story:** As a user, I want to reset my financial data, so that I can start fresh if needed.

#### Acceptance Criteria

1. THE Application SHALL provide a data reset option in settings
2. WHEN the User initiates data reset, THE Application SHALL display a confirmation dialog
3. WHEN the User confirms data reset, THE Application SHALL delete all Income, Expense, and Recurring_Entry records from the Database
4. WHEN data reset completes, THE Application SHALL preserve User profile and Budget_Config settings
5. WHEN data reset completes, THE Application SHALL navigate to the Dashboard showing empty state

### Requirement 14: Data Persistence

**User Story:** As a user, I want all my data to be saved locally, so that I can use the application offline without losing information.

#### Acceptance Criteria

1. THE Application SHALL store all data in the local Hive Database
2. WHEN the User adds or modifies any data, THE Application SHALL persist changes to the Database immediately
3. WHEN the Application restarts, THE Application SHALL load all data from the Database
4. THE Application SHALL function fully without any network connection
5. THE Application SHALL not require any backend API or cloud services

### Requirement 15: Navigation

**User Story:** As a user, I want to navigate smoothly between different screens, so that I can access all features efficiently.

#### Acceptance Criteria

1. THE Application SHALL use named routes for all navigation
2. WHEN the User navigates to a new screen, THE Application SHALL use GetX navigation methods
3. THE Application SHALL maintain proper navigation stack for back button functionality
4. WHEN the User presses the back button on the Dashboard, THE Application SHALL exit the app or show exit confirmation
5. THE Application SHALL initialize proper GetX bindings for each feature screen

### Requirement 16: Input Validation

**User Story:** As a user, I want the application to validate my inputs, so that I don't enter invalid data.

#### Acceptance Criteria

1. WHEN the User enters an amount, THE Application SHALL validate that it is a positive number
2. WHEN the User enters text fields, THE Application SHALL validate that required fields are non-empty
3. WHEN validation fails, THE Application SHALL display an error message indicating the specific validation issue
4. WHEN validation fails, THE Application SHALL prevent form submission
5. THE Application SHALL trim whitespace from text inputs before validation

### Requirement 17: Error Handling

**User Story:** As a user, I want to see clear error messages when something goes wrong, so that I understand what happened and how to fix it.

#### Acceptance Criteria

1. WHEN a Database operation fails, THE Application SHALL display a user-friendly error message
2. WHEN an unexpected error occurs, THE Application SHALL log the error details for debugging
3. WHEN an error occurs, THE Application SHALL not crash or leave the User in an invalid state
4. THE Application SHALL provide specific error messages rather than generic ones
5. WHEN an error is recoverable, THE Application SHALL provide guidance on how to resolve it

### Requirement 18: Performance Optimization

**User Story:** As a user, I want the application to be fast and responsive, so that I have a smooth experience.

#### Acceptance Criteria

1. THE Application SHALL use const constructors for widgets that don't change
2. THE Application SHALL use Obx widgets for reactive updates to minimize rebuilds
3. WHEN querying Database for monthly data, THE Application SHALL filter by month and year using indexed queries
4. THE Application SHALL separate UI code from business logic using GetX controllers
5. THE Application SHALL avoid rebuilding the entire screen when only a small part changes

### Requirement 19: User Interface Design

**User Story:** As a user, I want a modern and attractive interface, so that the application is pleasant to use.

#### Acceptance Criteria

1. THE Application SHALL implement Material 3 design guidelines
2. THE Application SHALL use rounded cards with consistent spacing and padding
3. THE Application SHALL use a cohesive color scheme with soft, professional colors
4. THE Application SHALL use smooth animations for transitions and interactions
5. THE Application SHALL be responsive and adapt to different screen sizes
6. THE Application SHALL use custom reusable widgets for consistent UI elements
7. THE Application SHALL display empty states with helpful messages when no data exists

### Requirement 20: Database Schema

**User Story:** As a developer, I want a well-structured database schema, so that data is organized efficiently and relationships are clear.

#### Acceptance Criteria

1. THE Database SHALL store User data with fields: name and currency
2. THE Database SHALL store Category data with fields: name, percentage, and type
3. THE Database SHALL store SubCategory data with fields: name and categoryId
4. THE Database SHALL store Income data with fields: amount, source, month, year, and date
5. THE Database SHALL store Expense data with fields: amount, categoryId, subcategoryId, date, and description
6. THE Database SHALL store Budget_Config data with fields: needsPercent, wantsPercent, and savingsPercent
7. THE Database SHALL store Recurring_Entry data with fields: amount, type, frequency, categoryId, and subcategoryId
8. WHEN the Application first initializes, THE Application SHALL create all required Database boxes and seed default data
