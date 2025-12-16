import 'package:demo_poc/constants/db_store.dart';
import 'package:demo_poc/models/budget.dart';
import 'package:hive/hive.dart';

class BudgetHiveDao {
  Box<Budget> get _box => Hive.box<Budget>(kBudgetBoxName);

  List<Budget> getAll() {
    final budgets = _box.values.toList();
    // Sort by createdAt descending
    budgets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return budgets;
  }

  Future<void> addBudget(Budget budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> updateBudget(Budget budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> saveAll(List<Budget> budgets) async {
    await _box.clear();
    final Map<String, Budget> entries = {for (var b in budgets) b.id: b};
    await _box.putAll(entries);
  }
}
