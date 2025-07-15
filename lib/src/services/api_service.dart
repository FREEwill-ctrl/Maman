
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://api.kluster.ai/v1";
  static const String _model = "deepseek-ai/DeepSeek-R1-0528";
  static String? _apiKey;

  static Future<void> _loadApiKey() async {
    final secrets = await rootBundle.loadString('assets/secrets.json');
    final data = json.decode(secrets);
    _apiKey = data['api_key'];
  }

  static Future<String> getChatbotResponse(String userMessage) async {
    if (_apiKey == null) {
      await _loadApiKey();
    }

    try {
      String enhancedPrompt = """Kamu adalah chatbot AI dengan kepribadian seperti karakter dari anime Grand Blue. 
      Kamu suka humor, santai, dan sering membicarakan tentang menyelam, pantai, dan kehidupan kampus yang seru. 
      Jawab dengan gaya yang ceria, lucu, dan kadang sedikit berlebihan seperti karakter Grand Blue. 
      Gunakan bahasa Indonesia yang santai dan friendly.
      
      Pesan user: $userMessage""";

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
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'] ??
              "Hmm, sepertinya aku kehilangan kata-kata... seperti saat pertama kali menyelam! 🤿";
        } else {
          return "Maaf, aku tidak bisa mendapatkan respons saat ini 😅";
        }
      } else {
        return "Waduh, ada masalah teknis nih! Seperti peralatan selam yang rusak 😵 (Error: ${response.statusCode})";
      }
    } catch (e) {
      return "Ups! Koneksi bermasalah seperti sinyal di bawah laut! 📶❌ Coba lagi ya!";
    }
  }
}
