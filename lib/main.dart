
import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/providers/chat_provider.dart';
import 'package:grand_blue_chatbot_daus/src/screens/chat_screen.dart';
import 'package:grand_blue_chatbot_daus/src/services/api_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services before running the app
  await ApiService.initialize();
  
  runApp(const GrandBlueChatbotApp());
}

class GrandBlueChatbotApp extends StatelessWidget {
  const GrandBlueChatbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: MaterialApp(
        title: 'Grand Blue Chatbot',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00BCD4), // Cyan - Ocean blue
            secondary: Color(0xFFFFC107), // Amber - Sun/Sand
            surface: Color(0xFFE0F7FA), // Light cyan - Sky
            onSurface: Colors.black87,
            background: Color(0xFFE1F5FE), // Very light blue
          ),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF00BCD4),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black26,
            titleTextStyle: TextStyle(
              fontFamily: 'Roboto', 
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
          ),
        ),
        home: const ChatScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
