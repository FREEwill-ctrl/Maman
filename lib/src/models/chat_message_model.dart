import 'package:flutter/foundation.dart' show immutable;

@immutable
class ChatMessageModel {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessageModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}