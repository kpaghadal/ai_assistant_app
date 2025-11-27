import 'package:flutter/material.dart';
import 'ui_theme.dart';
import 'gemini_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GeminiService _gemini = GeminiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> messages = [
    {"role": "assistant", "text": "Hi! I’m your AI assistant. How can I help today?"},
  ];

  Future<void> sendMessage() async {
    String userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userText});
      _controller.clear();
    });

    // Scroll down after user message
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

    // Get Gemini AI reply
    String reply = await _gemini.getResponse(userText);

    setState(() {
      messages.add({"role": "assistant", "text": reply});
    });

    // Scroll down after response
    await Future.delayed(const Duration(milliseconds: 200));
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      appBar: const AppHeader(title: 'AI Assistant App', showBack: true),
      body: Column(
        children: [
          // Title section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: const [
                SizedBox(height: 4),
                Text('Chat', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                SizedBox(height: 12),
                Divider(height: 1, color: Color(0xFFBFD7C7)),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";
                return Column(
                  crossAxisAlignment:
                      isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF16A34A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          msg["text"] ?? '',
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 15,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Input bar
          Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.mic_none, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Message the assistant...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Send'),
                  ),
                ),
              ],
            ),
          ),

          // Bottom navigation mock
          _bottomNavMock(),
        ],
      ),
    );
  }

  Widget _bottomNavMock() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F5F1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _NavIcon(icon: Icons.home_outlined),
          _NavIcon(icon: Icons.history),
          _NavIcon(icon: Icons.settings_outlined),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 28, color: Colors.black87);
  }
}


















