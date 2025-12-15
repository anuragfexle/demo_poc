import 'package:demo_poc/constants/db_store.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:hive/hive.dart';

class ExpenseHiveDao {
  Box<Expense> get _box => Hive.box<Expense>(kExpenseBoxName);

  List<Expense> getAll() {
    final expenses = _box.values.toList();
    expenses.sort((a, b) => b.date!.compareTo(a.date!));
    return expenses;
  }

  Future<void> addExpense(Expense expense) async {
    // use id as key
    await _box.put(expense.id, expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
