import 'package:flutter/material.dart';
import 'ui_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _name = TextEditingController(text: 'AI Assistant');
  final TextEditingController _email = TextEditingController(text: 'aiassistantapp@gmail.com');
  final TextEditingController _phone = TextEditingController(text: '+91 76765 87609');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
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
              const Center(child: Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              // Header card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: const [
                    CircleAvatar(radius: 28, backgroundColor: Color(0xFFE6F4EA), child: Icon(Icons.person, color: Colors.black87)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ai Assistant app', style: TextStyle(fontWeight: FontWeight.w800)),
                          SizedBox(height: 2),
                          Text('Update your personal info', style: TextStyle(color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Basic info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Basic info', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _field(label: 'Full Name', controller: _name),
                    const SizedBox(height: 12),
                    _field(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    _field(label: 'Phone', controller: _phone, keyboardType: TextInputType.phone),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Actions card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            elevation: 0,
                          ),
                          child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA7D9B8),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            elevation: 0,
                          ),
                          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
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

  Widget _field({required String label, required TextEditingController controller, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
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


