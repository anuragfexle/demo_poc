import 'package:demo_poc/main.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:demo_poc/routes/app_routes.dart';
import 'package:demo_poc/screens/expense/AddExpense.dart';
import 'package:demo_poc/screens/expense/UpdateExpense.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.expenses:
      case AppRoutes.budget:
      case AppRoutes.profile:
        // All main tab routes go to HomeScreen
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.addExpense:
        return MaterialPageRoute(builder: (_) => const AddExpense());

      case AppRoutes.updateExpense:
        final expense = settings.arguments as Expense?;
        if (expense == null) {
          return _errorRoute('Expense data is required');
        }
        return MaterialPageRoute(
          builder: (_) => UpdateExpense(expense: expense),
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
