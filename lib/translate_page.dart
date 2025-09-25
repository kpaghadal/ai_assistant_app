import 'package:flutter/material.dart';
import 'ui_theme.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final String _from = 'English';
  final String _to = 'German';
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

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
              const Center(child: Text('Translate', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              // Instant translation card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: const [
                    CircleAvatar(radius: 24, backgroundColor: Color(0xFFE6F4EA), child: Icon(Icons.translate)),
                    SizedBox(width: 12),
                    Expanded(
                      child: _InstantText(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Language pickers row
              Row(
                children: [
                  Expanded(child: _langPill(_from, onTap: () {})),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.swap_horiz, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _langPill(_to, onTap: () {})),
                ],
              ),

              const SizedBox(height: 16),

              // Your Text
              _label('Your Text'),
              const SizedBox(height: 8),
              _textarea(hint: 'Paste or type text to translate...'),

              const SizedBox(height: 16),
              _label('Translation'),
              const SizedBox(height: 8),
              _textarea(hint: 'Translation will be appear here.'),

              const SizedBox(height: 16),

              // Bottom input + button bar
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
                ]),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.mic_none),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 44,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Text('Ask AI to translate...', style: TextStyle(color: AppColors.textMuted)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 0,
                        ),
                        child: const Text('Translate'),
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

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));

  Widget _textarea({required String hint}) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _input,
        maxLines: null,
        decoration: const InputDecoration.collapsed(hintText: ''),
      ),
    );
  }

  Widget _langPill(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFA7D9B8),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
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
          Icon(Icons.history, size: 30, color: Colors.black87),
          Icon(Icons.settings, size: 30, color: Colors.black87),
        ],
      ),
    );
  }
}

class _InstantText extends StatelessWidget {
  const _InstantText();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Instant translation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        SizedBox(height: 4),
        Text('Type or paste text and get a high-quality translation', style: TextStyle(color: AppColors.textMuted)),
      ],
    );
  }
}


