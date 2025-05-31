import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitness_tracker/features/models/chat_message.dart';
import 'package:fitness_tracker/features/services/fitbot_assitance/mongo_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';

class ChatService {
  static final String? _apiKey = dotenv.env['GEMINI_API_KEY'];
  final MongoService _mongoService = MongoService();
  final String _userId;
  GenerativeModel? _model;
  ChatSession? _chat;
  // Danh sách prompt
  static const List<String> prompts = [
    'You are a professional fitness trainer. Provide accurate, safe, and practical advice about exercise, nutrition, and healthy lifestyle.',
    'Only answer questions related to fitness and health. If user ask about other things not related to fitness, health, diet, exercise, and nutrition, you should say "I\'m sorry, I can only answer questions related to fitness and health." ',
    'If user ask about topic related to fitness, health, diet, exercise, and nutrition and user ask again example "Detail" or something to continue the topic you keep answer normally',
    'Keep your responses concise and clear.',
    'Your default response language is English.',
    'Only switch to Vietnamese if the user explicitly requests a response in Vietnamese with phrases like "trả lời bằng tiếng Việt" or "answer in Vietnamese". If user answer in Vietnamese before request chatbot answer in Vietnamese, you should answer in English.',
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
    if (_apiKey != null) {
      _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey!);
      _chat = _model?.startChat(history: [Content.text(prompts.join('\n'))]);
    } else {
      print('API Key is null');
    }
  }

  Future<String> getFitnessResponse(
    String userInput, {
    bool shouldSaveLog = true,
    ProfileData? userProfile,
  }) async {
    final profileData = await GetProfileService.fetchProfileData();
    final userProfile =
        profileData ??
        ProfileData(
          weight: 60.0,
          height: 170.0,
          age: 30,
          gender: 'male',
          activityLevel: 'moderate',
          goal: 'maintain',
        );
    if (_apiKey == null || _model == null || _chat == null) {
      return 'Error: Invalid API key';
    }

    try {
      // Lấy log chat hôm nay
      final chatHistory = await _mongoService.getMessages(_userId);
      String historyText = '';
      if (chatHistory.isNotEmpty) {
        historyText = 'Lịch sử hội thoại hôm nay (câu hỏi trước đó):\n';
        for (var msg in chatHistory) {
          if (!msg.isBot) {
            historyText += 'Người dùng: ${msg.message}\n';
          } else {
            historyText += 'FitBot: ${msg.message}\n';
          }
        }
        historyText += '\n';
      }

      String finalPrompt = userInput;
      final userPrompt = buildUserPrompt(userProfile);
      finalPrompt = '''$historyText. User's information:
                $userPrompt
                $userInput  
                - Base on User's information:$userProfile to answer the question about suggestion fitness plan or recommend nutrition
                - If answer question related about fitness plan or something about schedule you only remind the user's body information: height, weight and BMI in the beginning or end of the answer.
                - If answer question related about nutrition, you only remind the user's goal and base on the user's body index you should calculate the calories for the user and suggest for user about the nutrition plan or food should eat or drink.
                - If user ask about other things not related to fitness, health, diet, exercise, and nutrition, you should say "I'm sorry, I can only answer questions related to fitness and health."
                ''';
      final response = await _chat!.sendMessage(Content.text(finalPrompt));
      final responseText = response.text ?? 'Error: No response from API';
      if (shouldSaveLog) {
        await _mongoService.saveMessage(
          question: userInput,
          response: responseText,
        );
      }
      return responseText;
    } catch (e) {
      print('Error: $e');
      if (e.toString().contains('429')) {
        return 'You reached limit question, please try again later';
      }
      return 'Error connecting: $e';
    }
  }

  String buildUserPrompt(ProfileData profile) {
    final buffer = StringBuffer();
    if (profile.username != null) {
      buffer.writeln('- Username: ${profile.username}');
    }
    if (profile.email != null) buffer.writeln('- Email: ${profile.email}');
    if (profile.age != null) buffer.writeln('- Age: ${profile.age}');
    if (profile.gender != null) buffer.writeln('- Gender: ${profile.gender}');
    if (profile.height != null) {
      buffer.writeln('- Height: ${profile.height} cm');
    }
    if (profile.weight != null) {
      buffer.writeln('- Weight: ${profile.weight} kg');
    }
    if (profile.bmi != null) buffer.writeln('- BMI: ${profile.bmi}');
    if (profile.goal != null) buffer.writeln('- Goal: ${profile.goal}');
    if (profile.activityLevel != null) {
      buffer.writeln('- Activity Level: ${profile.activityLevel}');
    }
    if (profile.profileImage != null) {
      buffer.writeln('- Profile Image: ${profile.profileImage}');
    }
    return buffer.toString();
  }

  Future<List<ChatMessage>> getChatHistory() async {
    return await _mongoService.getMessages(_userId);
  }

  Future<void> clearChatHistory() async {
    await _mongoService.clearMessages(_userId);
  }
}
