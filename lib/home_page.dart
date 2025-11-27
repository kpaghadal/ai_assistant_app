import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ui_theme.dart';
import 'chat_page.dart';
import 'translate_page.dart';
import 'story_generator_page.dart';
import 'settings_page.dart';
import 'calculator_page.dart'; 
import 'weather_page.dart'; 
import 'calendar_page.dart';                
import 'notes_page.dart';
import 'speech_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Welcome!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      appBar: const AppHeader(title: 'Ai Assistant App'),
      bottomNavigationBar: _BottomNav(onSettings: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                _userName.isNotEmpty ? 'Welcome, $_userName!' : 'Welcome!',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.softCircle,
                      child: Icon(Icons.psychology_alt_outlined, color: Colors.black87),
                    ),
                    SizedBox(width: 14),
                    Expanded(child: _PromoText()),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Tools',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              // Row 1
              Row(
                children: [
                  Expanded(
                    child: _ToolCard(
                      title: 'Chat with AI',
                      subtitle: 'Ask me anything',
                      icon: Icons.chat_bubble_outline,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ChatPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ToolCard(
                      title: 'Weather',
                      subtitle: 'Check weather',
                      icon: Icons.cloud_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WeatherPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

             
              Row(
                children: [
                Expanded(
                    child: _ToolCard(
                      title: 'Speech',
                      subtitle: 'TTS / STT',
                      icon: Icons.mic_outlined,
                      onTap: () {
                          Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SpeechPage()),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ToolCard(
                      title: 'Translator',
                      subtitle: 'Easy translation',
                      icon: Icons.translate,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const TranslatePage()),
                        );
                      },
                    ),
                  ),
                 
                ],
              ),
              const SizedBox(height: 16),

            
              Row(
                children: [
                  Expanded(
                    child: _ToolCard(
                      title: 'Calculator',
                      subtitle: 'Smart calculator',
                      icon: Icons.calculate_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CalculatorPage()),
                        );
                      },
                    ),
                  ),
                
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ToolCard(
                    title: 'Calendar',
                    subtitle: 'Set reminders',
                    icon: Icons.calendar_today_outlined,
                    onTap: () {
                      Navigator.of(context).push(
                         MaterialPageRoute(builder: (_) => const CalendarPage()),
                      );                 
                    },
                  ),
                  ),
                              ],
                           ),

              const SizedBox(height: 16),

              
              Row(
                children: [
                  Expanded(
                    child: _ToolCard(
                      title: 'Notes',
                      subtitle: 'Take notes',
                      icon: Icons.note_alt_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotesPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ToolCard(
                      title: 'Story Generator',
                      subtitle: 'Create your story',
                      icon: Icons.menu_book_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const StoryGeneratorPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoText extends StatelessWidget {
  const _PromoText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Think Less, Do More!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 4),
        Text(
          'Pick a task or just start using it now.',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.softCircle,
              child: Icon(icon, color: Colors.black87, size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({this.onSettings});
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: AppColors.navBar,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.home, size: 30, color: Colors.black87),
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.black87),
            onPressed: onSettings,
          ),
        ],
      ),
    );
  }
}
