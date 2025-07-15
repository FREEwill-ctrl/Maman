import 'package:flutter/material.dart';
import 'package:grand_blue_chatbot_daus/src/providers/chat_provider.dart';
import 'package:grand_blue_chatbot_daus/src/widgets/chat_message_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to the provider to scroll down when new messages are added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChatProvider>();
      provider.addListener(_scrollToBottom);
    });
  }

  @override
  void dispose() {
    final provider = context.read<ChatProvider>();
    provider.removeListener(_scrollToBottom);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _ChatAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/grand_blue_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: const Column(
          children: <Widget>[
            Expanded(child: _ChatMessages()),
            _LoadingIndicator(),
            _TextInput(),
          ],
        ),
      ),
    );
  }
}

// --- AppBar Widget ---
class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.waves, color: Color(0xFF00BCD4), size: 24),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Grand Blue AI'),
              Text(
                'Diving into conversations! 🌊',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- Chat Messages List ---
class _ChatMessages extends StatelessWidget {
  const _ChatMessages();

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes in ChatProvider
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          reverse: true,
          itemCount: provider.messages.length,
          itemBuilder: (_, int index) => ChatMessageWidget(
            chatMessage: provider.messages[index],
          ),
        );
      },
    );
  }
}

// --- Loading Indicator ---
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (!provider.isLoading) return const SizedBox.shrink();

        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF00BCD4),
                child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Sedang menyelam mencari jawaban...',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                ),
              ),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Text Input Area ---
class _TextInput extends StatefulWidget {
  const _TextInput();

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatProvider>().sendMessage(text);
    _textController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<ChatProvider>().isLoading;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
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
              ),
              enabled: !isLoading,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isLoading ? null : () => _handleSubmitted(_textController.text),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}