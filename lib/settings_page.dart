import 'package:flutter/material.dart';
import 'ui_theme.dart';
import 'profile_page.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dark = false;

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
              const Center(child: Text('Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              // Account -> Profile
              _card(
                title: 'Account',
                child: _rowTile(
                  icon: Icons.account_circle_outlined,
                  title: 'Profile',
                  subtitle: 'Name, email, phone',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Preference -> Dark Mode
              _card(
                title: 'Preference',
                child: _rowTile(
                  icon: Icons.nightlight_round,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: dark,
                    onChanged: (v) => setState(() => dark = v),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // About Us
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rowTile(
                      icon: Icons.info_outline,
                      title: 'About Us',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      ),
                    ),
                    const Divider(height: 24),
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            elevation: 0,
                          ),
                          child: const Text('Sign out', style: TextStyle(fontWeight: FontWeight.w700)),
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

  Widget _card({String? title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _rowTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(radius: 24, backgroundColor: const Color(0xFFE6F4EA), child: Icon(icon, color: Colors.black87)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: AppColors.textMuted)) : null,
      trailing: trailing,
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


