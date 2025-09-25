import 'package:flutter/material.dart';

class AppColors {
  static const Color brandGreen = Color(0xFF16A34A);
  static const Color mintBackground = Color(0xFFD7EBDD);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color card = Colors.white;
  static const Color background = Color(0xFFCFE7D6); // Mint green
  static const Color cardBackground = Colors.white;
  static const Color softCircle = Color(0xFFE6F4EA);
  static const Color navBar = Color(0xFFE9F0EB);
}




class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  const AppHeader({super.key, required this.title, this.showBack = false});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.mintBackground,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () {},
            ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

InputDecoration roundedInputDecoration({String? hint, Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
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
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brandGreen, width: 2),
    ),
  );
}


