import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/features/models/chat_message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MongoService {
  Future<void> saveMessage({
    required String question,
    required String response,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token invalid or not logged in!');
    }
    final url = Uri.parse('${ApiConfig.baseUrl}/writeLog');
    final body = {'question': question, 'response': response};
    final res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Error saving chatlog: ${res.body}');
    }
  }

  Future<List<ChatMessage>> getMessages(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token invalid or not logged in!');
    }
    final url = Uri.parse('${ApiConfig.baseUrl}/getTodayLogs');
    final res = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body);
    final List<dynamic> logs = data['data'];
    if (logs.isEmpty) {
      print('Log is empty');
      return [];
    }
    final latestLog = logs[0];
    final List<dynamic> logData = latestLog['log_data'] ?? [];

    return logData.expand((item) {
      final ts = item['timestamp'];
      DateTime timestamp;
      if (ts is String) {
        timestamp = DateTime.tryParse(ts) ?? DateTime.now();
      } else {
        timestamp = DateTime.now();
      }
      return [
        ChatMessage(
          id: item['_id'] ?? '',
          message: item['question'] ?? '',
          isBot: false,
          timestamp: timestamp,
          userId: userId,
        ),
        ChatMessage(
          id: item['_id'] ?? '',
          message: item['response'] ?? '',
          isBot: true,
          timestamp: timestamp,
          userId: userId,
        ),
      ];
    }).toList();
  }

  Future<void> clearMessages(String userId) async {
    // TODO: Implement MongoDB connection and clear messages
  }
}
