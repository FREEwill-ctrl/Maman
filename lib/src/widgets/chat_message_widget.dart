
import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/models/chat_message_model.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({required this.chatMessage, super.key});

  final ChatMessageModel chatMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: chatMessage.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!chatMessage.isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 12.0),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF00BCD4),
                child: Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: chatMessage.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: chatMessage.isUser
                        ? const Color(0xFF00BCD4)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(chatMessage.isUser ? 20 : 4),
                      bottomRight: Radius.circular(chatMessage.isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    chatMessage.text,
                    style: TextStyle(
                      color: chatMessage.isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(chatMessage.timestamp),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (chatMessage.isUser) ...[
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFFFC107),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
