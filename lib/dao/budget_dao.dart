import 'package:demo_poc/models/budget.dart';
import 'package:demo_poc/services/api_client.dart';
import 'package:demo_poc/constants/constants.dart';

class BudgetDao {
  final ApiClient _apiClient = ApiClient(baseUrl: baseUrl);

  Future<List<Budget>> fetchBudget() async {
    final List<dynamic> data = await _apiClient.getList(budgetEndPoint);

    return data.map((e) => Budget.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> deleteBudget(String id) async {
    await _apiClient.delete('$budgetEndPoint/$id');
  }
}
