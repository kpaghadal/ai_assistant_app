import 'package:flutter/material.dart';
import 'ui_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
              const Center(child: Text('About Us', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              _card(
                child: const Text(
                  'AI Assistant is your smart companion that helps with daily tasks like chatting, generating stories, images, reminders, and much more. Our mission is to make AI simple and useful for everyone.',
                  style: TextStyle(color: AppColors.textMuted, height: 1.4, fontSize: 16),
                ),
              ),

              const SizedBox(height: 16),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Developed By', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 12),
                    _infoField(label: 'Company', value: 'ai assistant'),
                    const SizedBox(height: 12),
                    _infoField(label: 'Email', value: 'aiassistantapp@gmail.com'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('App version', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Version 1.0.0'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }

  Widget _infoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        Container(
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
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
          Icon(Icons.history, size: 30, color: Colors.black87),
          Icon(Icons.settings, size: 30, color: Colors.black87),
        ],
      ),
    );
  }
}


