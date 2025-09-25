import 'package:flutter/material.dart';
import 'ui_theme.dart';
import 'chat_page.dart';
import 'translate_page.dart';
import 'image_generator_page.dart';
import 'story_generator_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      bottomNavigationBar: _BottomNav(onSettings: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    'AI Assistant',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome !',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
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
              const SizedBox(height: 16),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: AppColors.textMuted),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ask me anything....',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Tools',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ToolCard(
                      title: 'Chat with AI',
                      subtitle: 'Ask me anything',
                      icon: Icons.chat_bubble_outline,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatPage()));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ToolCard(
                      title: 'Translator',
                      subtitle: 'Language made easy',
                      icon: Icons.translate,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TranslatePage()));
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
                      title: 'Story Generator',
                      subtitle: 'Crate your story',
                      icon: Icons.menu_book_outlined,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoryGeneratorPage()));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ToolCard(
                      title: 'Image Generator',
                      subtitle: 'Turn Words to pictures',
                      icon: Icons.image_outlined,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ImageGeneratorPage()));
                      },
                    ),
                  ),
                ],
              ),
              
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
        Text('Think Less, Do More!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        SizedBox(height: 4),
        Text('Pick a task or just start typing below.', style: TextStyle(color: AppColors.textMuted)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.softCircle,
              child: Icon(icon, color: Colors.black87),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textMuted)),
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
          const Icon(Icons.history, size: 30, color: Colors.black87),
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.black87),
            onPressed: onSettings,
          ),
        ],
      ),
    );
  }
}
