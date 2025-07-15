import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// Custom exception for better error handling
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = "https://api.kluster.ai/v1";
  static const String _model = "deepseek-ai/DeepSeek-R1-0528";
  static String? _apiKey;

  // Load the API key only once
  static Future<void> initialize() async {
    if (_apiKey != null) return;
    try {
      final secrets = await rootBundle.loadString('assets/secrets.json');
      final data = json.decode(secrets);
      _apiKey = data['api_key'];
    } catch (e) {
      // If secrets fail to load, we should know immediately.
      throw ApiException("Failed to load API credentials. Please check your assets/secrets.json file.");
    }
  }

  static Future<String> getChatbotResponse(String userMessage) async {
    if (_apiKey == null) {
      // This should ideally not be called here, but as a fallback.
      await initialize();
    }

    const String promptTemplate = """Kamu adalah chatbot AI dengan kepribadian seperti karakter dari anime Grand Blue. 
      Kamu suka humor, santai, dan sering membicarakan tentang menyelam, pantai, dan kehidupan kampus yang seru. 
      Jawab dengan gaya yang ceria, lucu, dan kadang sedikit berlebihan seperti karakter Grand Blue. 
      Gunakan bahasa Indonesia yang santai dan friendly.
      
      Pesan user: """;
      
    final String enhancedPrompt = "$promptTemplate$userMessage";

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': enhancedPrompt},
          ],
          'max_tokens': 500,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        final content = data['choices']?[0]?['message']?['content'];
        
        if (content != null) {
          return content;
        } else {
          throw ApiException("Hmm, sepertinya aku kehilangan kata-kata... seperti saat pertama kali menyelam! 🤿");
        }
      } else {
        // Provide more specific error from the API if possible
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorBody?['error']?['message'] ?? "No error message provided.";
        throw ApiException("Waduh, ada masalah teknis nih! (Error ${response.statusCode}: $errorMessage)");
      }
    } on http.ClientException catch (e) {
      // Handle network-related errors
      throw ApiException("Ups! Koneksi bermasalah seperti sinyal di bawah laut! 📶❌ Coba lagi ya! Details: ${e.message}");
    } catch (e) {
      // Catch any other unexpected errors
      throw ApiException("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }
}