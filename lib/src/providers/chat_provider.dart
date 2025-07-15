import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/models/chat_message_model.dart';
import 'package:grand_blue_chatbot_daus/src/services/api_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatProvider() {
    _addBotMessage("Halo! Aku adalah chatbot Grand Blue! 🌊 Ayo ngobrol tentang menyelam, pantai, atau hal lucu lainnya! 😄");
  }

  void _addMessage(ChatMessageModel message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  void _addBotMessage(String text) {
    _addMessage(ChatMessageModel(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _setLoading(bool loadingState) {
    _isLoading = loadingState;
    notifyListeners();
  }

  void _setError(String? errorText) {
    _error = errorText;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    // Clear previous errors
    _setError(null);

    // Add user message to the list
    _addMessage(ChatMessageModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // Set loading state
    _setLoading(true);

    try {
      // Get response from the bot
      final botResponse = await ApiService.getChatbotResponse(text);
      _addBotMessage(botResponse);
    } on ApiException catch (e) {
      // Handle API errors gracefully
      _addBotMessage(e.toString());
    } catch (e) {
      // Handle other unexpected errors
      _addBotMessage("Terjadi kesalahan yang tidak terduga. Coba lagi nanti.");
    } finally {
      // Always turn off loading state
      _setLoading(false);
    }
  }
}