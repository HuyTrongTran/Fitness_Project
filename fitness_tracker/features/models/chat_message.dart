class ChatMessage {
  final String id;
  final String message;
  final bool isBot;
  final DateTime timestamp;
  final bool isWelcomeMessage;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isBot,
    required this.timestamp,
    this.isWelcomeMessage = false,
  });
}
