import 'package:flutter/material.dart';
import 'login_page.dart';
import 'onboarding_one.dart';
import 'onboarding_two.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
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