
import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/models/chat_message_model.dart';
import 'package:grand_blue_chatbot_daus/src/services/api_service.dart';
import 'package:grand_blue_chatbot_daus/src/widgets/chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessageModel> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessageModel(
      text: "Halo! Aku adalah chatbot Grand Blue! 🌊 Ayo ngobrol tentang menyelam, pantai, atau hal lucu lainnya! 😄",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.insert(0, ChatMessageModel(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _getChatbotResponse(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _getChatbotResponse(String userMessage) async {
    final botResponse = await ApiService.getChatbotResponse(userMessage);
    setState(() {
      _isLoading = false;
      _messages.insert(0, ChatMessageModel(
        text: botResponse,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.waves,
                color: Color(0xFF00BCD4),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grand Blue AI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Diving into conversations! 🌊',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00BCD4),
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/grand_blue_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                reverse: true,
                itemBuilder: (_, int index) => ChatMessageWidget(chatMessage: _messages[index]),
                itemCount: _messages.length,
              ),
            ),
            if (_isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFF00BCD4),
                        child: Icon(Icons.smart_toy, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F7FA),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Sedang menyelam mencari jawaban...',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: const Color(0xFF00BCD4).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration(
                hintText: 'Ketik pesan kamu di sini...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: const Color(0xFF00BCD4),
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _isLoading ? null : () => _handleSubmitted(_textController.text),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.send,
                    color: _isLoading ? Colors.grey : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
