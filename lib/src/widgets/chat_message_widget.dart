import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/models/chat_message_model.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({required this.chatMessage, super.key});

  final ChatMessageModel chatMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isUser = chatMessage.isUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isUser) ...[
            const _BotAvatar(),
            const SizedBox(width: 12.0),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _MessageBubble(chatMessage: chatMessage),
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
          if (isUser) ...[
            const SizedBox(width: 12.0),
            const _UserAvatar(),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Color(0xFF00BCD4),
      child: Icon(
        Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Color(0xFFFFC107),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.chatMessage});

  final ChatMessageModel chatMessage;

  @override
  Widget build(BuildContext context) {
    final bool isUser = chatMessage.isUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF00BCD4) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        chatMessage.text,
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontSize: 16,
          height: 1.3,
        ),
      ),
    );
  }
}