import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitness_tracker/features/models/chat_message.dart';
import 'package:fitness_tracker/features/services/chat_service/mongo_service.dart';
import 'package:uuid/uuid.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static final String? _apiKey = dotenv.env['GEMINI_API_KEY'];
  final MongoService _mongoService = MongoService();
  final String _userId;
  GenerativeModel? _model;
  ChatSession? _chat;

  // Danh sách prompt
  static const List<String> prompts = [
    'You are a professional fitness trainer. Provide accurate, safe, and practical advice about exercise, nutrition, and healthy lifestyle.',
    'Only answer questions related to fitness and health. If user ask about other things not related to fitness, health, diet, exercise, and nutrition, you should say "I\'m sorry, I can only answer questions related to fitness and health."',
    'Keep your responses concise and clear.',
    'Your default response language is English.',
    'Only switch to Vietnamese if the user explicitly requests a response in Vietnamese with phrases like "trả lời bằng tiếng Việt" or "answer in Vietnamese".',
    'Do not use any special characters like asterisks (*), bold (**), or any other formatting symbols.',
    'Do not use any markdown formatting or special text styling.',
    'When listing items, ALWAYS use bullet points with the "•" character at the start of each item. NEVER use asterisks (*) or any other characters for bullet points.',
    'Example of correct bullet points format:',
    '• Consider adding healthy snacks between meals',
    '• A handful of nuts or a yogurt with fruit',
    '• Fresh vegetables with hummus',
    'Format your responses in a clean, readable way without any special characters or formatting.',
    'For mathematical formulas, you can use standard notation like "Weight (kg) / [Height (m)]²" for BMI calculation in metric units, or "BMI = [weight (lb) / height (in) squared] x 703" for imperial units.',
    'Make your responses sound conversational and easy to understand.',
    'Avoid using technical symbols or mathematical notation unless absolutely necessary.',
    'Write in plain text format only, without any special formatting or emphasis.',
    'If you need to emphasize something, use natural language instead of special characters.',
    'Example of good response: "The formula calculates BMI by dividing weight by height squared."',
    'Example of bad response: "The formula **calculates** BMI by dividing weight by height squared."',
  ];

  ChatService(this._userId) {
    print('API Key: $_apiKey');
    if (_apiKey != null) {
      _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey!);
      _chat = _model?.startChat(history: [Content.text(prompts.join('\n'))]);
    } else {
      print('API Key is null');
    }
  }

  Future<String> getFitnessResponse(String userInput) async {
    if (_apiKey == null || _model == null || _chat == null) {
      return 'Error: Invalid API key';
    }

    try {
      final response = await _chat!.sendMessage(Content.text(userInput));
      final responseText = response.text ?? 'Error: No response from API';
      return responseText;
    } catch (e) {
      print('Error: $e');
      if (e.toString().contains('429')) {
        return 'You reached limit question, please try again later';
      }
      return 'Error connecting: $e';
    }
  }

  Future<void> saveMessage(String message, bool isBot) async {
    final chatMessage = ChatMessage(
      id: const Uuid().v4(),
      message: message,
      isBot: isBot,
      timestamp: DateTime.now(),
      userId: _userId,
    );
    await _mongoService.saveMessage(chatMessage);
  }

  Future<List<ChatMessage>> getChatHistory() async {
    return await _mongoService.getMessages(_userId);
  }

  Future<void> clearChatHistory() async {
    await _mongoService.clearMessages(_userId);
  }
}
