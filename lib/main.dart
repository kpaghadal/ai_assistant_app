import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'login_page.dart';
import 'onboarding_one.dart';
import 'onboarding_two.dart';
import 'theme_provider.dart';
import 'ui_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'AI Assistant App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/onboard1',
      routes: {
        '/onboard1': (_) => const OnboardingOne(),
        '/onboard2': (_) => const OnboardingTwo(),
        '/login': (_) => const LoginPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
