# Nested Navigator with Named Routes - Implementation Guide

## Overview
The app now uses a **nested Navigator** approach for tab navigation. This allows:
- Navigation between tabs using named routes
- Passing parameters between screens
- No sliding of the entire screen (bottom navigation stays fixed)
- Programmatic navigation from buttons within screens

## Architecture

### Main Navigator (App Level)
- Defined in `MaterialApp` with `onGenerateRoute`
- Handles routes like `/add-expense` and `/update-expense`
- These routes show full-screen pages WITHOUT bottom navigation

### Nested Navigator (Tab Level)
- Defined inside `HomeScreen` widget
- Has its own `GlobalKey<NavigatorState>`
- Handles tab routes: `/expenses`, `/budget`, `/profile`
- All these routes keep the bottom navigation visible

## How It Works

### 1. HomeScreen Structure
```dart
class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  void _switchScreen(int index, {String? params}) {
    setState(() => _currentIndex = index);
    _navigatorKey.currentState!.pushReplacementNamed(
      tabs[index].routeName,
      arguments: params,
    );
  }
}
```

### 2. Navigation Methods

#### From Bottom Tab Bar
```dart
onTap: () => _switchScreen(index)
```
- Updates `_currentIndex`
- Uses nested navigator to switch routes
- No parameters passed

#### From Button in Screen
```dart
ElevatedButton(
  onPressed: () {
    onNavigate?.call(2, params: 'Text From Budget');
  },
  child: Text('Go to Profile'),
)
```
- Calls `_switchScreen` with index and params
- Parameters are passed via route arguments

### 3. Parameter Passing

**Budget Screen → Profile Screen:**
```dart
onNavigate?.call(2, params: 'Text From Budget');
```

**Profile Screen receives:**
```dart
class ProfilePage extends StatelessWidget {
  final String? params;
  final Function(int, {String? params})? onNavigate;
  
  const ProfilePage({super.key, this.params, this.onNavigate});
}
```

## Screen Implementation

### Budget Page
- Has 2 buttons: "Go to Profile" and "Go to Expense"
- Displays received params in blue text
- Passes "Text From Budget" when navigating

### Profile Page  
- Has 2 buttons: "Go to Expense" and "Go to Budget"
- Displays received params in green text
- Passes "Text From Profile" when navigating

### Expense Page
- Displays received params in orange banner at top
- Has FAB to add new expense
- Uses main navigator for add/update (full screen)

## Key Benefits

✅ **No Screen Sliding** - Bottom navigation stays fixed
✅ **Named Routes** - All navigation uses route names
✅ **Parameter Passing** - Easy to pass data between tabs
✅ **Programmatic Navigation** - Navigate from anywhere in code
✅ **State Preservation** - Each tab maintains its state
✅ **Clean Separation** - Tab navigation vs full-screen navigation

## Route Flow

```
App Navigator (Main)
├── /expenses → HomeScreen (with nested navigator)
├── /budget → HomeScreen (with nested navigator)
├── /profile → HomeScreen (with nested navigator)
├── /add-expense → AddExpense (full screen)
└── /update-expense → UpdateExpense (full screen)

Nested Navigator (Inside HomeScreen)
├── /expenses → ExpensePage
├── /budget → BudgetPage
└── /profile → ProfilePage
```

## Example Usage

**Navigate from Budget to Profile with params:**
```dart
onNavigate?.call(2, params: 'Text From Budget');
```

**Navigate from Profile to Expense with params:**
```dart
onNavigate?.call(0, params: 'Text From Profile');
```

The index corresponds to the tab position in the `tabs` array:
- 0 = Expenses
- 1 = Budget
- 2 = Profile
