import 'package:demo_poc/constants/db_store.dart';
import 'package:demo_poc/models/budget.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:demo_poc/models/profile.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(ProfileAdapter());

  await Hive.openBox<Expense>(kExpenseBoxName);
  await Hive.openBox<Budget>(kBudgetBoxName);
  await Hive.openBox<Profile>(kProfileBoxName);
}
