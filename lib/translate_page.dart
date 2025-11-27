import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'ui_theme.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  String _from = 'English';
  String _to = 'German';
  final TextEditingController _input = TextEditingController();
  final TextEditingController _output = TextEditingController();

  final Map<String, String> _languageCodes = {
    'English': 'en',
    'Hindi': 'hi',
    'German': 'de',
    'Spanish': 'es',
    'French': 'fr',
    'Italian': 'it',
    'Japanese': 'ja',
  };

  @override
  void dispose() {
    _input.dispose();
    _output.dispose();
    super.dispose();
  }

  Future<void> _translateText() async {
    if (_input.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter text to translate")),
      );
      return;
    }

    final translator = GoogleTranslator();

    try {
      var translation = await translator.translate(
        _input.text,
        from: _languageCodes[_from]!,
        to: _languageCodes[_to]!,
      );

      setState(() {
        _output.text = translation.text;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Translation failed: $e")),
      );
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFE7D6),
      appBar: const AppHeader(title: 'AI Assistant App', showBack: true),
      bottomNavigationBar: _bottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Translate',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              // Instant translation card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: const [
                    CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFE6F4EA),
                        child: Icon(Icons.translate)),
                    SizedBox(width: 12),
                    Expanded(child: _InstantText()),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Language pickers row
              Row(
                children: [
                  Expanded(
                    child: _langPill(_from, onTap: () => _selectLang(true)),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _swapLanguages,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.swap_horiz, size: 28),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _langPill(_to, onTap: () => _selectLang(false)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Input Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Text',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _input,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Paste or type text to translate...',
                        hintStyle:
                            const TextStyle(color: AppColors.textMuted),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.brandGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Output Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Translation',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _output,
                      maxLines: 5,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Translation will appear here...',
                        hintStyle:
                            const TextStyle(color: AppColors.textMuted),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.brandGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Translate Button
              Center(
                child: ElevatedButton(
                  onPressed: _translateText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('Translate',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Select language dialog
  void _selectLang(bool isFrom) async {
    String? selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(isFrom ? "Select source language" : "Select target language"),
        children: _languageCodes.keys.map((lang) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, lang),
            child: Text(lang),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        if (isFrom) {
          _from = selected;
        } else {
          _to = selected;
        }
      });
    }
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
            Text(text,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
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
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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

class _InstantText extends StatelessWidget {
  const _InstantText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Instant translation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        SizedBox(height: 4),
        Text('Type or paste text and get a high-quality translation',
            style: TextStyle(color: AppColors.textMuted)),
      ],
    );
  }
}
