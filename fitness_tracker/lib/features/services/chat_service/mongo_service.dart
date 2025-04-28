import 'package:fitness_tracker/features/models/chat_message.dart';

class MongoService {
  Future<void> saveMessage(ChatMessage message) async {
    // TODO: Implement MongoDB connection and save message
  }

  Future<List<ChatMessage>> getMessages(String userId) async {
    // TODO: Implement MongoDB connection and get messages
    return [];
  }

  Future<void> clearMessages(String userId) async {
    // TODO: Implement MongoDB connection and clear messages
  }
}
