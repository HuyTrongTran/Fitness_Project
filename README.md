# Ứng dụng Theo dõi Sức khỏe - Flutter Application

Ứng dụng theo dõi sức khỏe toàn diện được xây dựng trên nền tảng Flutter, giúp người dùng theo dõi sức khỏe, lập kế hoạch tập luyện, theo dõi tiến độ và nhận hướng dẫn thể dục thông minh từ AI. Được phát triển với các công nghệ hiện đại bao gồm xác thực Firebase, tích hợp Google Maps và Gemini AI cho việc huấn luyện thể dục thông minh.

## 📱 Tính năng

### Xác thực & Quản lý Người dùng
- **Xác thực Email/Mật khẩu** với hệ thống xác minh
- **Đăng nhập Mạng xã hội** (Google & Facebook OAuth)
- **Quản lý Mật khẩu** (Đổi mật khẩu, quên mật khẩu)
- **Quản lý Hồ sơ Người dùng** với theo dõi chỉ số cơ thể (tính toán BMI)

### Tính năng Thể dục Cốt lõi
- **Lập kế hoạch & Theo dõi Tập luyện** với các bài tập có thể tùy chỉnh
- **Tính toán Calo** sử dụng công thức MET (Metabolic Equivalent)
- **Theo dõi Phiên Chạy bộ** với tích hợp GPS
- **Biểu đồ Tiến độ & Phân tích** sử dụng thư viện FL Chart
- **Tích hợp Lịch** để lên lịch tập luyện
- **Theo dõi Chỉ số Cơ thể** (BMI, cân nặng, chiều cao)

### Tính năng Thông minh
- **Chatbot Thể dục AI (FitBot)** được hỗ trợ bởi Google Gemini AI
- **Gợi ý Bài tập Cá nhân hóa** dựa trên hồ sơ người dùng
- **Thông báo Thông minh** cho lời nhắc tập luyện
- **Khuyến nghị Hoạt động** phù hợp với mục tiêu người dùng

### Tính năng Bổ sung
- **Bản đồ Tương tác** cho các tuyến đường chạy/đi bộ
- **Giao diện UI/UX Đẹp mắt** với Google Fonts và hoạt ảnh tùy chỉnh
- **Lưu trữ Offline** với bộ nhớ đệm cục bộ
- **Hỗ trợ Đa ngôn ngữ**
- **Hỗ trợ Chủ đề Tối/Sáng**

## 🛠️ Công nghệ Sử dụng

### Frontend
- **Flutter** (SDK ^3.7.0)
- **Dart** ngôn ngữ lập trình
- **Provider** cho quản lý trạng thái
- **GetX** cho điều hướng và quản lý trạng thái

### Backend & APIs
- **Node.js API** triển khai trên DigitalOcean
- **MongoDB** cho lưu trữ dữ liệu
- **JWT Authentication** cho truy cập API bảo mật
- **RESTful API** kiến trúc

### Dịch vụ Firebase
- **Firebase Authentication** cho quản lý người dùng
- **Firebase Core** cho khởi tạo ứng dụng
- **Google Sign-In** tích hợp
- **Facebook Authentication** tích hợp

### Tích hợp Bên ngoài
- **Google Maps** cho theo dõi vị trí
- **Google Gemini AI** cho chatbot thể dục
- **Geolocator** cho chức năng GPS
- **Image Picker** cho ảnh hồ sơ

### Thư viện UI/UX
- **Google Fonts** cho kiểu chữ
- **FL Chart** cho trực quan hóa dữ liệu
- **Iconsax** cho biểu tượng hiện đại
- **Carousel Slider** cho thư viện ảnh
- **Smooth Page Indicator** cho giới thiệu ứng dụng

## 📋 Yêu cầu Tiên quyết

Trước khi chạy ứng dụng này, đảm bảo bạn có:

- **Flutter SDK** (phiên bản 3.7.0 trở lên)
- **Dart** (bao gồm với Flutter)
- **Android Studio** hoặc **VS Code** với phần mở rộng Flutter
- **Firebase Project** đã thiết lập
- **Google Maps API Key**
- **Gemini AI API Key**

## 🚀 Cài đặt & Thiết lập

### 1. Sao chép Repository
```bash
git clone https://github.com/HuyTrongTran/Fitness_Project.git
cd fitness_tracker
```

### 2. Cài đặt Dependencies
```bash
flutter pub get
```

### 3. Cấu hình Biến Môi trường
Tạo hoặc cập nhật tệp `.env` trong `assets/.env`:
```properties
GEMINI_API_KEY=your_gemini_api_key_here
JWT_SECRET=your_jwt_secret_here
MONGODB_URI=your_mongodb_connection_string
```

### 4. Cấu hình Firebase
- Đảm bảo `firebase_options.dart` được cấu hình đúng
- Thêm `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)

### 5. Thiết lập Google Maps
- Thêm Google Maps API key vào cấu hình Android và iOS
- Kích hoạt các dịch vụ Google Maps cần thiết trong Google Cloud Console

### 6. Chạy Ứng dụng
```bash
# Cho chế độ debug
flutter run

# Cho chế độ release
flutter run --release
```

## 🔧 Cấu hình API

Ứng dụng kết nối với backend API được triển khai trên DigitalOcean:

**Base URL:** `https://fitness-tracking-qfkrj.ondigitalocean.app/api`

### Các API Endpoint Chính:
- **Xác thực:** `/login`, `/register`, `/verify-email`
- **Hồ sơ Người dùng:** `/getProfile`, `/update-profile`
- **Dữ liệu Tập luyện:** `/activity-data`, `/submit-workout`
- **Phiên Chạy bộ:** `/submit-run-session`
- **Nhật ký Chat:** `/writeLog`, `/getTodayLogs`
- **Quản lý Mật khẩu:** `/update-password`

## 🧪 Tài khoản Thử nghiệm

Để thử nghiệm, bạn có thể sử dụng các tài khoản demo sau:

### Tài khoản Demo
```
Email: demo@fitnessapp.com
Mật khẩu: demo123
```

## 📱 Hướng dẫn Sử dụng

### Bắt đầu
1. **Tải xuống và cài đặt** ứng dụng trên thiết bị của bạn
2. **Tạo tài khoản** hoặc đăng nhập với thông tin đăng nhập hiện có
3. **Hoàn thành quá trình giới thiệu** (chiều cao, cân nặng, tuổi, mục tiêu thể dục)
4. **Thiết lập hồ sơ thể dục** và mục tiêu của bạn

### Sử dụng Tính năng Cốt lõi

#### Lập kế hoạch Tập luyện
- Điều hướng đến màn hình chính
- Xem các bài tập được đề xuất dựa trên hồ sơ của bạn
- Tạo kế hoạch tập luyện tùy chỉnh
- Theo dõi các bài tập đã hoàn thành và calo đã đốt cháy

#### Theo dõi Chạy bộ
- Truy cập tính năng chạy bộ từ menu chính
- Bắt đầu theo dõi GPS cho việc chạy của bạn
- Giám sát khoảng cách, tốc độ và calo
- Lưu và xem lại lịch sử chạy bộ của bạn

#### Chat Thể dục AI
- Mở tính năng chat FitBot
- Đặt câu hỏi về:
  - Thói quen tập luyện
  - Lời khuyên dinh dưỡng
  - Kỹ thuật tập luyện
  - Lập kế hoạch mục tiêu thể dục

#### Theo dõi Tiến độ
- Xem phân tích và biểu đồ thể dục của bạn
- Theo dõi BMI và thành phần cơ thể
- Theo dõi tính nhất quán trong tập luyện
- Xem lại xu hướng đốt cháy calo

## 📂 Cấu trúc Dự án

```
lib/
├── api/                          # Cấu hình API
├── common/                       # Widget và tiện ích dùng chung
├── features/
│   ├── models/                   # Mô hình dữ liệu
│   └── services/                 # Dịch vụ logic nghiệp vụ
├── screens/                      # Màn hình UI
│   ├── authentication/           # Đăng nhập, đăng ký, quản lý mật khẩu
│   ├── home/                     # Bảng điều khiển chính
│   ├── onboardingFeature/        # Luồng giới thiệu người dùng
│   ├── settings/                 # Cài đặt ứng dụng và hồ sơ
│   └── userProfile/              # Quản lý hồ sơ người dùng
├── utils/                        # Tiện ích và hỗ trợ
│   ├── constants/                # Hằng số ứng dụng
│   ├── helpers/                  # Hàm hỗ trợ
│   └── validation/               # Xác thực form
└── main.dart                     # Điểm vào ứng dụng
```

## 🔐 Tính năng Bảo mật

- **JWT Token Authentication** cho bảo mật API
- **Mã hóa Mật khẩu** và lưu trữ bảo mật
- **Xác thực Đầu vào** và làm sạch dữ liệu
- **Giao tiếp API Bảo mật** với HTTPS

## 🌟 Cải tiến Tương lai

- Tích hợp với thiết bị đeo (Apple Watch, Fitbit)
- Tính năng xã hội (thách thức bạn bè, bảng xếp hạng)
- Lập kế hoạch bữa ăn và theo dõi dinh dưỡng
- Video hướng dẫn tập luyện
- Phân tích và thông tin chi tiết nâng cao
- Bản địa hóa đa ngôn ngữ

## 🐛 Khắc phục Sự cố

### Các Vấn đề Thường gặp

1. **Lỗi Build:**
   - Chạy `flutter clean` sau đó `flutter pub get`
   - Đảm bảo tất cả biến môi trường được thiết lập đúng

2. **Vấn đề Kết nối API:**
   - Kiểm tra kết nối internet
   - Xác minh Base URL API trong `apiUrl.dart`
   - Đảm bảo JWT token hợp lệ

3. **Firebase Authentication:**
   - Xác minh các tệp cấu hình Firebase
   - Kiểm tra cài đặt dự án Firebase
   - Đảm bảo các phương thức xác thực được kích hoạt

4. **Google Maps Không Tải:**
   - Xác minh Google Maps API key
   - Kích hoạt các API cần thiết trong Google Cloud Console
   - Kiểm tra cấu hình theo nền tảng

## 📞 Hỗ trợ & Liên hệ

Để được hỗ trợ kỹ thuật hoặc có câu hỏi:
- **Email:** fitness.app@support.com.vn
- **Repository Dự án:** https://github.com/HuyTrongTran/Fitness_Project.git
- **Tài liệu API:** Có sẵn tại repository backend

## 📄 Giấy phép

Dự án này được phát triển như một phần của luận văn tốt nghiệp (KLTN) và nhằm mục đích giáo dục và trình diễn.

---

**Phiên bản:** 1.0.0+1  
**Cập nhật Lần cuối:** Tháng 12 năm 2024  
**Nền tảng:** Flutter (Android & iOS)
