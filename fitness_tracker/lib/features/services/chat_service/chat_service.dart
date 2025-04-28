import 'package:fitness_tracker/features/models/chat_message.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final _uuid = const Uuid();
  List<ChatMessage> _messages = [];

  Future<void> sendMessage(String message, String userId) async {
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      message: message,
      isBot: false,
      timestamp: DateTime.now(),
      userId: userId,
    );
    _messages.add(userMessage);

    // Simulate bot response
    await Future.delayed(const Duration(seconds: 1));
    final botMessage = ChatMessage(
      id: _uuid.v4(),
      message:
          'Hello! I am your virtual assistant. How can I help you?',
      isBot: true,
      timestamp: DateTime.now(),
      userId: userId,
    );
    _messages.add(botMessage);
  }

  List<ChatMessage> getMessages(String userId) {
    return _messages.where((msg) => msg.userId == userId).toList();
  }

  void clearMessages(String userId) {
    _messages.removeWhere((msg) => msg.userId == userId);
  }
}
