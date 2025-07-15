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
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";
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
      await initialize();
    }

    const String systemInstruction = """Kamu adalah chatbot AI dengan kepribadian seperti karakter dari anime Grand Blue. 
      Kamu suka humor, santai, dan sering membicarakan tentang menyelam, pantai, dan kehidupan kampus yang seru. 
      Jawab dengan gaya yang ceria, lucu, dan kadang sedikit berlebihan seperti karakter Grand Blue. 
      Gunakan bahasa Indonesia yang santai dan friendly.""";

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            // System/persona instruction
            { 'role': 'user', 'parts': [{ 'text': systemInstruction }]},
            { 'role': 'model', 'parts': [{ 'text': "Siap! Aku akan jadi teman ngobrolmu yang paling asyik!" }]},
            // Actual user message
            { 'role': 'user', 'parts': [{ 'text': userMessage }]}
          ],
          'generationConfig': {
            'temperature': 0.8,
            'maxOutputTokens': 500,
          },
          'safetySettings': [
            { 'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE' },
            { 'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE' },
            { 'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE' },
            { 'category': 'HARM_CATEGORY_DANGEROUS_CONTENT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE' },
          ]
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        
        if (content != null) {
          return content;
        } else {
          final finishReason = data['candidates']?[0]?['finishReason'];
          if (finishReason == 'SAFETY') {
            throw ApiException("Waduh, jawabanku diblokir karena terlalu berbahaya! Mungkin kita bahas yang lebih santai saja? 😅");
          }
          throw ApiException("Hmm, sepertinya aku kehilangan kata-kata... seperti saat pertama kali menyelam! 🤿");
        }
      } else {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorBody?['error']?['message'] ?? "No error message provided.";
        throw ApiException("Waduh, ada masalah teknis nih! (Error ${response.statusCode}: $errorMessage)");
      }
    } on http.ClientException catch (e) {
      throw ApiException("Ups! Koneksi bermasalah seperti sinyal di bawah laut! 📶❌ Coba lagi ya! Details: ${e.message}");
    } catch (e) {
      throw ApiException("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }
}