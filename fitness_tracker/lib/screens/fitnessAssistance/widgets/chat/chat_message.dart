import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:intl/intl.dart';
import 'animated_text.dart';

class ChatMessage extends StatelessWidget {
  final bool isBot;
  final String message;
  final String timestamp;
  final bool isWelcomeMessage;

  const ChatMessage({
    Key? key,
    required this.isBot,
    required this.message,
    required this.timestamp,
    this.isWelcomeMessage = false,
  }) : super(key: key);

  String _formatTimestamp(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('dd/MM/yy HH:mm').format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  Widget _buildAvatar(bool isBot) {
    if (isBot) {
      return Container(
        width: 35,
        height: 35,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: TColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/icons/app_icons/robot.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return FutureBuilder<ProfileData?>(
        future: ApiService.fetchProfileData(),
        builder: (context, snapshot) {
          return Container(
            width: 35,
            height: 35,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TColors.primary.withOpacity(0.1),
            ),
            child: ClipOval(
              child:
                  snapshot.hasData && snapshot.data?.profileImage != null
                      ? Image.network(
                        snapshot.data!.profileImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: TColors.primary,
                            size: 20,
                          );
                        },
                      )
                      : const Icon(
                        Icons.person,
                        color: TColors.primary,
                        size: 20,
                      ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) _buildAvatar(true),
          Column(
            crossAxisAlignment:
                isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                margin: EdgeInsets.only(
                  left: isBot ? 8 : 0,
                  right: isBot ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: isBot ? Colors.white : TColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isBot ? 0 : 20),
                    bottomRight: Radius.circular(isBot ? 20 : 0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    isBot && isWelcomeMessage
                        ? AnimatedText(
                          text: message,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        )
                        : Text(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                            color: isBot ? Colors.black87 : Colors.white,
                          ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          if (!isBot) _buildAvatar(false),
        ],
      ),
    );
  }
}
