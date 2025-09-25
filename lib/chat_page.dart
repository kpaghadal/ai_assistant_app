import 'package:flutter/material.dart';
import 'ui_theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      appBar: const AppHeader(title: 'Ai Assistant App', showBack: true),
      body: Column(
        children: [
          // Title row 'Chat' with divider
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

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Suggestion card
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFE6F4EA),
                        child: Icon(Icons.settings_suggest_outlined, color: Colors.black87),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Think Less, Do More!', style: TextStyle(fontWeight: FontWeight.w800)),
                            SizedBox(height: 4),
                            Text('Pick a task or just start typing below.',
                                style: TextStyle(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFBFD7C7)),
                const SizedBox(height: 12),

                _assistantBubble('Hi! I\'m your Ai assistant. How can i help today?'),
                const _Timestamp('Today 9:45'),
                _userBubble('Help me plan my afternoon errands.'),
                const _Timestamp('Today 9:46'),
                _assistantBubble(
                    'Sure -- Share your task, location, and time window, and i\'ll optimize a route and schedule.'),
                const _Timestamp('Today 9:47'),
              ],
            ),
          ),

          _inputBar(context),

          _bottomNavMock(),
        ],
      ),
    );
  }

  Widget _assistantBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(text, style: const TextStyle(fontSize: 15, height: 1.3)),
      ),
    );
  }

  Widget _userBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3),
        ),
      ),
    );
  }

  Widget _inputBar(BuildContext context) {
    return Container(
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
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              alignment: Alignment.centerLeft,
              child: const Text('message the assistant...',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Text('Send'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavMock() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(color: Color(0xFFF0F5F1),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
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

class _Timestamp extends StatelessWidget {
  const _Timestamp(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
      child: Text(text, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
    );
  }
}


