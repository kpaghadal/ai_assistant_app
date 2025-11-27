import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ui_theme.dart';
import 'profile_page.dart';
import 'about_page.dart';
import 'theme_provider.dart';
import 'login_page.dart';
import 'change_password_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.background,
      appBar: const AppHeader(title: 'AI Assistant', showBack: true),
      bottomNavigationBar: _bottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    )),
              ),
              const SizedBox(height: 8),
              Divider(
                  height: 1,
                  color: isDarkMode
                      ? Colors.grey.shade800
                      : const Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              // Account -> Profile & Change Password
              _card(
                title: 'Account',
                child: Column(
                  children: [
                    _rowTile(
                      icon: Icons.account_circle_outlined,
                      title: 'Profile',
                      subtitle: 'Name, email, phone',
                      trailing: Icon(Icons.chevron_right,
                          color: isDarkMode ? Colors.white70 : Colors.black54),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      ),
                    ),
                    Divider(
                        height: 24,
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300),
                    _rowTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      trailing: Icon(Icons.chevron_right,
                          color: isDarkMode ? Colors.white70 : Colors.black54),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const ChangePasswordPage()),
                      ),
                    ),
                  ],
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
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.setDarkMode(value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // About Us + Sign Out
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rowTile(
                      icon: Icons.info_outline,
                      title: 'About Us',
                      trailing: Icon(Icons.chevron_right,
                          color: isDarkMode ? Colors.white70 : Colors.black54),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      ),
                    ),
                    Divider(
                        height: 24,
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300),
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              // Sign out from Firebase
                              await FirebaseAuth.instance.signOut();
                              
                              // Clear any local data if needed
                              // await SharedPreferences.getInstance().then((prefs) => prefs.clear());

                              if (!context.mounted) return;

                              // Navigate to login page and remove all previous routes
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                                (route) => false,
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error signing out: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Sign out',
                              style: TextStyle(fontWeight: FontWeight.w700)),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black87),
            ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: isDarkMode
            ? AppColors.darkSoftCircle
            : const Color(0xFFE6F4EA),
        child: Icon(icon,
            color: isDarkMode ? Colors.white : Colors.black87),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black87),
      ),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkTextMuted
                      : AppColors.textMuted))
          : null,
      trailing: trailing,
    );
  }

  Widget _bottomBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkNavBar : const Color(0xFFE9F0EB),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home_outlined,
              size: 30, color: isDarkMode ? Colors.white : Colors.black87),
          
          Icon(Icons.settings,
              size: 30, color: isDarkMode ? Colors.white : Colors.black87),
        ],
      ),
    );
  }
}
