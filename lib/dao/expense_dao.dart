import 'package:demo_poc/models/expense.dart';
import 'package:demo_poc/services/api_client.dart';
import 'package:demo_poc/constants/constants.dart';

class ExpenseDao {
  final ApiClient _apiClient = ApiClient(baseUrl: baseUrl);

  Future<List<Expense>> fetchExpenses() async {
    final List<dynamic> data = await _apiClient.getList(expensesEndPoint);

    return data
        .map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
