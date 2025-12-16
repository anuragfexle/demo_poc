import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? '',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  // this get mthd wil return list of data.
  Future<List<dynamic>> getList(String path) async {
    final response = await _dio.get(path);

    if (response.statusCode == 200 && response.data is List) {
      return response.data;
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }

  Future<void> delete(String path) async {
    final response = await _dio.delete(path);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete: ${response.statusCode}');
    }
  }
}
