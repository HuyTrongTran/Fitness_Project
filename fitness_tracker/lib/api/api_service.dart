import 'package:http/http.dart' as http;
import 'apiUrl.dart';

class ApiService {
  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}$endpoint',
    ).replace(queryParameters: queryParameters);

    return await http.get(uri, headers: {'Content-Type': 'application/json'});
  }
}
