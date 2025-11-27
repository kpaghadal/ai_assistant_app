// lib/story_generator_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gemini_service.dart';
import 'ui_theme.dart';

class StoryGeneratorPage extends StatefulWidget {
  const StoryGeneratorPage({super.key});

  @override
  State<StoryGeneratorPage> createState() => _StoryGeneratorPageState();
}

class _StoryGeneratorPageState extends State<StoryGeneratorPage> {
  final TextEditingController _promptController = TextEditingController();
  final GeminiService _geminiService = GeminiService();

  File? _selectedImage;
  bool _loading = false;
  String _generatedStory = '';

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      // ignore or show error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image pick error: $e')));
    }
  }

  // Call Gemini service to generate story
  Future<void> _generateStory() async {
    final promptText = _promptController.text.trim();

    if (!_geminiService.isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add your Gemini API key (GEMINI_API_KEY) to use the story generator.',
          ),
        ),
      );
      return;
    }

    if (promptText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a prompt.')));
      return;
    }

    setState(() {
      _loading = true;
      _generatedStory = '';
    });

    try {
      List<int>? imageBytes;
      if (_selectedImage != null) {
        imageBytes = await _selectedImage!.readAsBytes();
      }

      final response = await _geminiService.generateStory(
        prompt: promptText,
        imageBytes: imageBytes,
      );

      if (!mounted) return;

      setState(() {
        _generatedStory = response;
      });

      if (response.toLowerCase().startsWith('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        // Success - show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Story generated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _generatedStory = 'Error while generating story: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _copyStory() async {
    if (_generatedStory.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _generatedStory));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Story copied to clipboard')));
  }

  Future<void> _saveStory() async {
    if (_generatedStory.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved =
        prefs.getStringList('saved_stories') ?? <String>[];
    saved.insert(0, _generatedStory);
    await prefs.setStringList('saved_stories', saved);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Story saved to history')),
    );
  }


  Widget _uploadBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Center(
          child: _selectedImage == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                    SizedBox(height: 6),
                    Text('Click to upload', style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('PNG, JPG or JPEG', style: TextStyle(color: Colors.grey)),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity, height: 120),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.mintBackground,
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
              if (!_geminiService.isConfigured)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Text(
                    'Gemini API key not found. Run the app with '
                    '--dart-define=GEMINI_API_KEY=your_key to enable story generation.',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                  ),
                ),

              // Upload box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upload an image (optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    _uploadBox(),
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
                      controller: _promptController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Once upon a time in a magical forest...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
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
                  onPressed: _loading ? null : _generateStory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 2,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Generate Story', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
                    _loading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Generating your story...',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          )
                        : _generatedStory.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.book_outlined,
                                          size: 48, color: Colors.grey),
                                      SizedBox(height: 12),
                                      Text(
                                        'Your story will appear here after generation.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Add a prompt and tap Generate to get started.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SelectableText(
                                _generatedStory,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _actionButton(
                          icon: Icons.copy_outlined, label: 'Copy', onTap: _copyStory)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _actionButton(
                          icon: Icons.save_outlined, label: 'Save', onTap: _saveStory)),
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
          
          Icon(Icons.settings, size: 30, color: Colors.black87),
        ],
      ),
    );
  }

}
