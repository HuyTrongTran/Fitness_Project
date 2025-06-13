import 'package:fitness_tracker/features/services/fitbot_assitance/mongo_service.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/screens/foodSuggestion/foodSuggestion.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/screens/fitnessAssistance/widgets/chat/chat_message.dart';
import 'package:fitness_tracker/screens/fitnessAssistance/widgets/chat/chat_input.dart';
import 'package:fitness_tracker/screens/fitnessAssistance/widgets/chat/chat_header.dart';
import 'package:fitness_tracker/screens/fitnessAssistance/widgets/chat/typing_indicator.dart';
import 'package:fitness_tracker/features/services/fitbot_assitance/chatServices.dart';
import 'package:fitness_tracker/features/models/chat_message.dart' as Model;

class FitnessAssistance extends StatefulWidget {
  const FitnessAssistance({Key? key}) : super(key: key);

  @override
  State<FitnessAssistance> createState() => _FitnessAssistanceState();
}

class _FitnessAssistanceState extends State<FitnessAssistance> {
  final TextEditingController _messageController = TextEditingController();
  final List<Model.ChatMessage> _messages = [];
  late ChatService _chatService;
  bool _isLoading = false;
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatService = ChatService('user123');
    _loadChatHistory();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  Future<void> _loadChatHistory() async {
    final messages = await _chatService.getChatHistory();
    setState(() {
      if (messages.isEmpty) {
        final welcomeMessage = Model.ChatMessage(
          id: 'welcome',
          message:
              "Hello! I'm your fitness assistant. How can I help you today?",
          isBot: true,
          timestamp: DateTime.now(),
          isWelcomeMessage: true,
        );
        _messages.add(welcomeMessage);
      } else {
        _messages.addAll(messages);
      }
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = Model.ChatMessage(
      id: DateTime.now().toString(),
      message: message,
      isBot: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await _chatService.getFitnessResponse(message);
      setState(() {
        _isTyping = false;
      });

      final botMessage = Model.ChatMessage(
        id: DateTime.now().toString(),
        message: response,
        isBot: true,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isTyping = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ChatHeader(),
            // Quick Actions Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuickActionButton(
                        context,
                        icon: Icons.restaurant,
                        label: 'Suggest food',
                        color: Colors.orange,
                        onTap: () {
                          
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildQuickActionButton(
                        context,
                        icon: Icons.fitness_center,
                        label: 'Workout',
                        color: Colors.blue,
                        onTap: () {
                          _sendMessage('Gợi ý bài tập phù hợp cho tôi');
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildQuickActionButton(
                        context,
                        icon: Icons.health_and_safety,
                        label: 'Health',
                        color: Colors.green,
                        onTap: () {
                          _sendMessage('Tư vấn về sức khỏe và dinh dưỡng');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    // Có thể thêm logic xử lý ở đây nếu cần
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TypingIndicator(isTyping: _isTyping),
                      );
                    }

                    final message = _messages[index];
                    return ChatMessage(
                      isBot: message.isBot,
                      message: message.message,
                      timestamp: message.timestamp.toString(),
                      isWelcomeMessage: message.isWelcomeMessage,
                    );
                  },
                ),
              ),
            ),
            if (_isLoading && !_isTyping)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(color: TColors.primary),
                ),
              ),
            ChatInput(
              onSendMessage: _sendMessage,
              controller: _messageController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
