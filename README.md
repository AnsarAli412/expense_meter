# 💰 Expense Meter
> ***Master your money with the 50/30/20 rule.***

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-purple.svg?style=for-the-badge&logo=flutter&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-orange.svg?style=for-the-badge&logo=hive&logoColor=white)

**Expense Meter** is a modern, offline-first Flutter application designed to help you manage your finances efficiently using the popular **50/30/20 budgeting rule**. Track your income, expenses, and savings seamlessly with a beautiful Material 3 design.

---

## ✨ Features

- **🏠 Smart Dashboard**: Get a quick overview of your financial health with real-time balance updates and budget progress bars.
- **📊 50/30/20 Budgeting**: Automatically categorizes your spending into:
    - **50% Needs**: Essential expenses like rent, groceries, and utilities.
    - **30% Wants**: Personal indulgences like dining out, entertainment, and shopping.
    - **20% Savings**: Future security like emergency funds and investments.
- **📝 Transaction Tracking**: Easily add income and expenses with detailed categorization.
- **📅 Recurring Entries**: Set up recurring income and expenses (monthly/yearly) so you never miss a payment.
- **📈 Insightful Reports**:
    - **Monthly Breakdown**: Visual pie charts to see where your money goes.
    - **Yearly Overview**: Bar charts comparing income vs. expense trends over the year.
- **🌗 Dark Mode**: Full support for light and dark themes to suit your preference.
- **🔒 Offline & Private**: All data is stored locally on your device using Hive. No internet required, no data sharing.
- **⚙️ Customizable**: Adjust the 50/30/20 percentages to fit your personal goals.

---

## 📱 Screenshots

|Splash|Profile Setup| Dashboard |Add Income| Add Expense |
|:---:|:---:|:---:|:---:|:---:
| <img src="https://github.com/AnsarAli412/expense_meter/blob/master/assets/screenshots/splash.jpeg" width="200" alt="Splash" /> |
<img src="https://github.com/AnsarAli412/expense_meter/blob/master/assets/screenshots/profile_setup.jpeg" width="200" alt="Profile Setup" /> |
<img src="https://github.com/AnsarAli412/expense_meter/blob/master/assets/screenshots/dashboard.jpeg" width="200" alt="Dashboard" /> |
<img src="https://github.com/AnsarAli412/expense_meter/blob/master/assets/screenshots/add_income.jpeg" width="200" alt="Add Income" /> | 
<img src="https://github.com/AnsarAli412/expense_meter/blob/master/assets/screenshots/add_expense.jpeg" width="200" alt="Add Expense" /> | 

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Local Database**: [Hive](https://pub.dev/packages/hive) (NoSQL)
- **Charting**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Navigation**: GetX Named Routes
- **Design System**: Material 3

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/      # AppColors, AppStrings
│   ├── models/         # Hive Models (User, Transaction, Category)
│   ├── services/       # HiveService, Storage logic
│   └── theme/          # AppTheme (Light/Dark)
├── features/
│   ├── dashboard/      # Dashboard UI & Controller
│   ├── income/         # Add Income Logic
│   ├── expense/        # Add Expense Logic
│   ├── reports/        # Monthly & Yearly Reports
│   ├── category/       # Category Management
│   ├── settings/       # Budget configuration & Theme toggle
│   ├── recurring/      # Recurring entries management
│   ├── onboarding/     # Intro screens
│   └── splash/         # App initialization
├── routes/             # AppRoutes & AppPages
├── shared/             # Reusable widgets
└── main.dart           # Entry point
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/expense_meter.git
    cd expense_meter
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the app**
    ```bash
    flutter run
    ```

4.  **Generate Adapters (if modifying models)**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

---

## 🤝 Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ using Flutter.
