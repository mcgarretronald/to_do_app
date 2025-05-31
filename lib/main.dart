import 'package:flutter/material.dart';
import 'package:to_do_app/Pages/splash_screen.dart';
import 'package:to_do_app/Pages/home_screen.dart';
import 'package:to_do_app/Pages/onboarding_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => HomePage(),
        '/onboarding': (context) => OnboardingScreen(),
        
      },
    );
  }
}