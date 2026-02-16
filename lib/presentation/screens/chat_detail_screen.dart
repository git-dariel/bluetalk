import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../models/chat_models.dart';
import 'package:ionicons/ionicons.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.title,
    required this.messages,
    required this.onSendMessage,
  });

  final String title;
  final List<ChatMessage> messages;
  final Future<void> Function(String text) onSendMessage;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final String text = _textController.text.trim();
    if (text.isEmpty || _sending) {
      return;
    }

    _textController.clear();
    setState(() {
      _sending = true;
    });

    await widget.onSendMessage(text);

    if (!mounted) {
      return;
    }
    setState(() {
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bluetalk.')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: const Color(0xFF6F8F6D),
                    child: Text(widget.title.substring(0, 1)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final ChatMessage message = widget.messages[index];
                    return Align(
                      alignment: message.fromMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 260),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: message.fromMe
                              ? BlueTalkColors.navPill
                              : const Color(0xFFD9C294),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.text,
                          style: const TextStyle(
                              fontSize: 15, color: BlueTalkColors.primaryText),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: BlueTalkColors.inputSurface,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        enabled: !_sending,
                        style: const TextStyle(
                            color: Color(0xFF163A33), fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Aa',
                          hintStyle:
                              TextStyle(color: Color(0xFF75847B), fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sending ? null : _sendMessage,
                      child: Icon(
                        Ionicons.send,
                        color: _sending
                            ? const Color(0xFF75847B)
                            : BlueTalkColors.primaryText,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
