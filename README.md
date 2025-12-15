# Demo POC - Expense Tracker

A robust Flutter application designed to help users track their daily expenses and manage their budget effectively. This project demonstrates modern Flutter development practices, including efficient state management and local data persistence.

## 🚀 Features

-   **Expense Management**:
    -   Add new expenses with details like name, amount, date, time, and category.
    -   View a list of all recorded expenses.
    -   Update existing expense details.
    -   Delete unwanted expenses.
-   **Insights**: Visual representation of expense data (Charts).
-   **Budgeting**: Basic budget management capabilities.
-   **Theme Customization**: Full support for Light, Dark, and System themes.
-   **Profile Management**: User profile settings.

## 🛠️ Tech Stack & Libraries

This project utilizes a curated list of packages to ensure performance and maintainability:

-   **Framework**: [Flutter](https://flutter.dev/)
-   **Language**: [Dart](https://dart.dev/)
-   **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) - Implements the BLoC (Business Logic Component) pattern to separate presentation from business logic.
-   **Local Storage**: [hive](https://pub.dev/packages/hive) & [hive_flutter](https://pub.dev/packages/hive_flutter) - A lightweight and blazing fast key-value database written in pure Dart.
-   **Navigation**: Flutter Named Routes for organized screen transitions.
-   **UI Components**: Material Design 3 components.

## 📂 Project Structure

The project follows a feature-first and clean architecture approach:

```
lib/
├── bloc/           # BLoC definitions (Events, States, Blocs)
├── components/     # Reusable UI widgets (e.g., ExpenseListItem)
├── config/         # Configuration files (e.g., AppTheme)
├── constants/      # App-wide constants
├── dao/            # Data Access Objects (Hive implementation)
├── models/         # Data models (Expense, etc.)
├── repositories/   # Repository pattern implementation
├── routes/         # Route generation and paths
├── screens/        # UI Screens (Expense, Budget, Profile)
├── utils/          # Utility classes (DateFormatter, etc.)
└── main.dart       # Application entry point
```

## 🏁 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

-   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
-   An IDE (VS Code, Android Studio, or IntelliJ) with Flutter plugins installed.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/anuragfexle/demo_poc.git
    cd demo_poc
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the application:**

    To run on a connected device or emulator:

    ```bash
    flutter run
    ```

    To run specifically on Chrome (web):

    ```bash
    flutter run -d chrome
    ```

## 📚 References

-   **Flutter Documentation**: [https://docs.flutter.dev/](https://docs.flutter.dev/)
-   **Bloc Library**: [https://bloclibrary.dev/](https://bloclibrary.dev/)
-   **Hive Documentation**: [https://docs.hivedb.dev/](https://docs.hivedb.dev/)

---

*This project is a Proof of Concept (POC) for demonstration purposes.*
