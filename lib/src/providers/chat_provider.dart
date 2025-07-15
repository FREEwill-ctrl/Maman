
import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/models/chat_message_model.dart';
import 'package:grand_blue_chatbot_daus/src/services/api_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatProvider() {
    _messages.add(ChatMessageModel(
      text: "Halo! Aku adalah chatbot Grand Blue! 🌊 Ayo ngobrol tentang menyelam, pantai, atau hal lucu lainnya! 😄",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.insert(0, ChatMessageModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isLoading = true;
    notifyListeners();

    try {
      final botResponse = await ApiService.getChatbotResponse(text);
      _messages.insert(0, ChatMessageModel(
        text: botResponse,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _messages.insert(0, ChatMessageModel(
        text: e.toString(),
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    _isLoading = false;
    notifyListeners();
  }
}
