class ChatMessage {
  final String id;
  final String message;
  final bool isBot;
  final DateTime timestamp;
  final String? userId;
  final bool isWelcomeMessage;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isBot,
    required this.timestamp,
    this.userId,
    this.isWelcomeMessage = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isBot': isBot,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'isWelcomeMessage': isWelcomeMessage,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      isBot: json['isBot'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['userId'],
      isWelcomeMessage: json['isWelcomeMessage'] ?? false,
    );
  }
}
