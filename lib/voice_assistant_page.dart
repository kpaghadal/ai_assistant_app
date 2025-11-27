import 'package:flutter/material.dart';
import 'ui_theme.dart';

class VoiceAssistantPage extends StatelessWidget {
  const VoiceAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFE7D6),
      appBar: const AppHeader(title: 'Ai Assistant App', showBack: true),
      bottomNavigationBar: _bottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('Voice  Assistant', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 24),

              const Center(
                child: Text('Hi , How Can I Help You Today?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),

              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                  ]),
                  child: const Icon(Icons.mic_none, size: 64),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Tap and speak your command', style: TextStyle(color: AppColors.textMuted)),
              ),

              const SizedBox(height: 24),

              // Conversation card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Conversation', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _assistantBubble('Hello! Ask me anything.'),
                    _userBubble('What is the weather like today?'),
                    _assistantBubble('Expect mild temperatures with partly cloudy skies.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _assistantBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE5E7EB))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.3))),
          ],
        ),
      ),
    );
  }

  Widget _userBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(18)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3)),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xFFE9F0EB),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home_outlined, size: 30, color: Colors.black87),
         
          Icon(Icons.settings, size: 30, color: Colors.black87),
        ],
      ),
    );
  }
}




