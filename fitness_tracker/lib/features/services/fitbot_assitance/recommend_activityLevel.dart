import 'package:fitness_tracker/features/services/fitbot_assitance/chatServices.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';

// Map cache tĩnh lưu kết quả AI đã gợi cho từng profile
final Map<String, Map<String, dynamic>> _aiTargetCache = {};

/// Hàm làm tròn số thập phân
double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

/// Hàm lấy key cache kèm ngày
String buildCacheKey({
  required double weight,
  required double height,
  required double bmi,
  required String goal,
  required int age,
  required String date, // thêm ngày
}) {
  return 'w:$weight-h:$height-bmi:$bmi-goal:$goal-age:$age-date:$date';
}

/// Hàm lấy ngày hiện tại dạng yyyy-MM-dd
String getTodayKey() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

/// Hàm lấy timestamp 00:00 ngày hôm sau
int getExpireTimestamp() {
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  return tomorrow.millisecondsSinceEpoch;
}

/// Hàm xây dựng prompt gửi cho Gemini
String buildTargetPrompt({
  required double weight,
  required double height,
  required double bmi,
  required String goal,
  required int age,
}) {
  return '''
Tôi là một người dùng với các thông tin sau:
- Age: $age
- Cân nặng: $weight kg
- Chiều cao: $height cm
- BMI: $bmi
- Mục tiêu: $goal

Bạn hãy gợi ý cho tôi mục tiêu phù hợp trong 1 ngày về:
- Quãng đường (km) nên đi/chạy nên gợi ý dựa trên độ tuổi, cân nặng và chiều cao của người dùng và cả BMI của người dùng
- Số bước chân (steps) nên đạt nên gợi ý dựa trên độ tuổi, cân nặng và chiều cao của người dùng và cả BMI của người dùng. Và một Một nghiên cứu năm 2011 cho thấy người trưởng thành khỏe mạnh có thể đi khoảng từ 4.000 đến 18.000 bước/ngày. Số bước đi mỗi ngày có thể được chia thành các mức như sau: Ít vận động: Đi bộ dưới 5.000 bước mỗi ngày. Vận động trung bình: Dao động từ 7.500 đến 9.999 bước mỗi ngày.
- Số bước chân (steps) nên phải được gợi ý dựa theo khoa học và các nghiên cứu về sức khỏe tập luyện không được gợi ý bậy bạ giống kiểu sau đây steps chỉ có 254 không đúng với thực tế: AI recommend: {distance: 4.0, steps: 254, calories: 1900, water: 2.5}.
- Lượng calories nên tiêu thụ bạn gợi ý theo độ tuổi, cân nặng và chiều cao của người dùng và cả BMI của người dùng mục tiêu của người dùng
- Và khi người dùng gọi lại với cùng các thông tin của người dùng thì bạn hãy gợi ý đúng với lần trước đó
- Lượng nước nên uống trong 1 ngày bạn hãy gợi ý theo độ tuổi, cân nặng và chiều cao của người dùng và cả BMI của người dùng mục tiêu của người dùng
Chỉ trả về kết quả dạng:
distance: <số km>
steps: <số bước>
calories: <số calo>
water: <số lít>
''';
}

/// Hàm gọi Gemini AI để gợi ý target cho 1 ngày dựa trên profile
Future<Map<String, dynamic>> recommendDailyTarget({
  required String userId,
  required int age,
  required double weight,
  required double height,
  required double bmi,
  required String goal,
  ProfileData? userProfile,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final today = getTodayKey();
  // Làm tròn số trước khi build key
  final roundedWeight = roundDouble(weight, 1);
  final roundedHeight = roundDouble(height, 1);
  final roundedBmi = roundDouble(bmi, 1);
  print(
    'Profile for recommend: weight=$roundedWeight, height=$roundedHeight, bmi=$roundedBmi, goal=$goal, age=$age, date=$today',
  );
  final cacheKey = buildCacheKey(
    age: age,
    weight: roundedWeight,
    height: roundedHeight,
    bmi: roundedBmi,
    goal: goal,
    date: today,
  );

  // // Log toàn bộ SharedPreferences
  // final allPrefs = prefs.getKeys();
  // for (final key in allPrefs) {
  //   print('SharedPreferences: $key => ${prefs.get(key)}');
  // }

  // Kiểm tra cache local (SharedPreferences) với try-catch
  final cachedData = prefs.getString(cacheKey);
  if (cachedData != null) {
    try {
      final cacheMap = jsonDecode(cachedData);
      final expire = cacheMap['expire'] as int?;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (expire != null && expire > now) {
        // Chưa hết hạn, trả về cache
        _aiTargetCache[cacheKey] = Map<String, dynamic>.from(
          cacheMap['data'] ?? {},
        );
        print('Lấy từ cache: $cacheKey => ${cacheMap['data']}');
        return Map<String, dynamic>.from(cacheMap['data'] ?? {});
      } else {
        // Hết hạn, xóa cache cũ
        await prefs.remove(cacheKey);
      }
    } catch (e) {
      print('Lỗi khi parse cache: $e, raw: $cachedData');
      await prefs.remove(cacheKey);
    }
  }

  // Nếu chưa có cache hoặc cache đã hết hạn, gọi AI
  print('Gọi AI recommend...');
  final chatService = ChatService(userId);
  final prompt = buildTargetPrompt(
    age: age,
    weight: roundedWeight,
    height: roundedHeight,
    bmi: roundedBmi,
    goal: goal,
  );
  final response = await chatService.getFitnessResponse(
    prompt,
    shouldSaveLog: false,
    userProfile: userProfile,
  );

  // Parse từng dòng thay vì regex toàn khối
  final lines = response.split('\n');
  String? distanceLine = lines.firstWhere(
    (l) => l.toLowerCase().contains('distance:'),
    orElse: () => '',
  );
  String? stepsLine = lines.firstWhere(
    (l) => l.toLowerCase().contains('steps:'),
    orElse: () => '',
  );
  String? caloriesLine = lines.firstWhere(
    (l) => l.toLowerCase().contains('calories:'),
    orElse: () => '',
  );
  String? waterLine = lines.firstWhere(
    (l) => l.toLowerCase().contains('water:'),
    orElse: () => '',
  );

  double parseRangeDouble(String? str) {
    if (str == null) return 0;
    final numbers =
        RegExp(
          r'[\d.]+',
        ).allMatches(str).map((m) => double.parse(m.group(0)!)).toList();
    if (numbers.isEmpty) return 0;
    if (numbers.length == 1) return numbers[0];
    return ((numbers[0] + numbers[1]) / 2);
  }

  int parseRange(String? str) {
    if (str == null) return 0;
    final numbers =
        RegExp(
          r'\d+',
        ).allMatches(str).map((m) => int.parse(m.group(0)!)).toList();
    if (numbers.isEmpty) return 0;
    if (numbers.length == 1) return numbers[0];
    return ((numbers[0] + numbers[1]) / 2).round();
  }

  final result = {
    'distance': parseRangeDouble(distanceLine),
    'steps': parseRange(stepsLine),
    'calories': parseRange(caloriesLine),
    'water': parseRangeDouble(waterLine),
  };
  print('AI recommend: $result');

  // Nếu tất cả đều > 0 thì cache lại và trả về, ngược lại trả map rỗng để fallback
  if (result.values.any((v) => v == 0)) return {};
  _aiTargetCache[cacheKey] = result;
  final cacheMap = {'expire': getExpireTimestamp(), 'data': result};
  await prefs.setString(cacheKey, jsonEncode(cacheMap)); // Lưu cache local
  return result;
}