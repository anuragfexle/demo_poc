import 'package:demo_poc/dao/budget_dao.dart';
import 'package:demo_poc/dao/budget_hive_dao.dart';
import 'package:demo_poc/models/budget.dart';

class BudgetRepository {
  final BudgetDao _apiDao;
  final BudgetHiveDao _localDao;

  BudgetRepository(this._apiDao, this._localDao);

  Future<List<Budget>> getBudgets() async {
    try {
      final apiBudgets = await _apiDao.fetchBudget();
      await _localDao.saveAll(apiBudgets);
      return _localDao.getAll();
    } catch (e) {
      // If API fails, return local data if available
      final localData = _localDao.getAll();
      if (localData.isNotEmpty) {
        return localData;
      }
      // If both API fails and local is empty, return empty list to prevent UI error
      return [];
    }
  }

  Future<void> deleteBudget(String id) async {
    await _apiDao.deleteBudget(id);
    await _localDao.deleteBudget(id);
  }
}
