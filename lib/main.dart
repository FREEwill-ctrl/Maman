import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/screens/chat_screen.dart';

void main() {
  runApp(const GrandBlueChatbotApp());
}

class GrandBlueChatbotApp extends StatelessWidget {
  const GrandBlueChatbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          elevation: 0,
        ),
      ),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}