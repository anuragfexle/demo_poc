import 'package:demo_poc/constants/db_store.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>(kExpenseBoxName);
}
