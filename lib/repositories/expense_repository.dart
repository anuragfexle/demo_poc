import 'package:demo_poc/dao/expense_hive_dao.dart';
import 'package:demo_poc/models/expense.dart';

class ExpenseRepository {
  final ExpenseHiveDao _localDao;

  ExpenseRepository(this._localDao);

  Future<List<Expense>> getExpenses() async {
    // only local Hive(DB) for the timebeing.
    // we will sync with API + cache here later.
    return _localDao.getAll();
  }

  Future<void> addExpense(Expense expense) {
    return _localDao.addExpense(expense);
  }

  Future<void> updateExpense(Expense expense) {
    return _localDao.updateExpense(expense);
  }

  Future<void> deleteExpense(String id) {
    return _localDao.deleteExpense(id);
  }
}
