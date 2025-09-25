import 'package:flutter/material.dart';
import 'ui_theme.dart';

class StoryGeneratorPage extends StatefulWidget {
  const StoryGeneratorPage({super.key});

  @override
  State<StoryGeneratorPage> createState() => _StoryGeneratorPageState();
}

class _StoryGeneratorPageState extends State<StoryGeneratorPage> {
  final TextEditingController _prompt = TextEditingController();

  @override
  void dispose() {
    _prompt.dispose();
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
              const Center(child: Text('Story Generator', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              // Upload box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upload an image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FBF8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.image_outlined, size: 40, color: AppColors.textMuted),
                            SizedBox(height: 6),
                            Text('Click to upload', style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(height: 2),
                            Text('PNG, JPG or JPEG', style: TextStyle(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Prompt card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        Icon(Icons.mic_none, color: AppColors.textMuted),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _prompt,
                      maxLines: 2,
                      decoration: roundedInputDecoration(hint: 'Once upon a time in a magical forest...'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Generate Story button
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 2,
                  ),
                  child: const Text('Generate Story', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ),
              ),

              const SizedBox(height: 16),

              // Preview card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FBF8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                        'Your story will appear here after Generation.\nAdd a prompt and tap Generate to get started.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _actionButton(icon: Icons.copy_outlined, label: 'Copy', onTap: () {})),
                  const SizedBox(width: 16),
                  Expanded(child: _actionButton(icon: Icons.save_outlined, label: 'Save', onTap: () {})),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
        ]),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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


