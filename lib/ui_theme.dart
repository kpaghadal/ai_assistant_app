import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color brandGreen = Color(0xFF16A34A);
  static const Color mintBackground = Color(0xFFD7EBDD);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color card = Colors.white;
  static const Color background = Color(0xFFCFE7D6); // Mint green
  static const Color cardBackground = Colors.white;
  static const Color softCircle = Color(0xFFE6F4EA);
  static const Color navBar = Color(0xFFE9F0EB);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkNavBar = Color(0xFF2C2C2C);
  static const Color darkSoftCircle = Color(0xFF2E2E2E);
  static const Color darkTextColor = Colors.white;
  static const Color darkTextMuted = Color(0xFFAAAAAA);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.mintBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    cardColor: AppColors.cardBackground,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDark),
      bodyMedium: TextStyle(color: AppColors.textDark),
      titleLarge: TextStyle(color: AppColors.textDark),
      titleMedium: TextStyle(color: AppColors.textDark),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brandGreen;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brandGreen.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.5);
      }),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    cardColor: AppColors.darkCardBackground,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextColor),
      bodyMedium: TextStyle(color: AppColors.darkTextColor),
      titleLarge: TextStyle(color: AppColors.darkTextColor),
      titleMedium: TextStyle(color: AppColors.darkTextColor),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brandGreen;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brandGreen.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.5);
      }),
    ),
  );
}




class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  const AppHeader({super.key, required this.title, this.showBack = false});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.mintBackground,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new, 
                color: isDarkMode ? Colors.white : Colors.black87
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : IconButton(
              icon: Icon(
                Icons.menu, 
                color: isDarkMode ? Colors.white : Colors.black87
              ),
              onPressed: () {},
            ),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

InputDecoration roundedInputDecoration({String? hint, Widget? prefixIcon, Widget? suffixIcon, BuildContext? context}) {
  final isDarkMode = context != null ? Theme.of(context).brightness == Brightness.dark : false;
  
  return InputDecoration(
    hintText: hint,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: isDarkMode ? AppColors.darkCardBackground : Colors.white,
    hintStyle: TextStyle(color: isDarkMode ? AppColors.darkTextMuted : AppColors.textMuted),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade800 : const Color(0xFFE5E7EB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade800 : const Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brandGreen, width: 2),
    ),
  );
}


