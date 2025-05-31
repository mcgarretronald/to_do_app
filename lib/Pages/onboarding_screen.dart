import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> slides = [
    {
      'title': 'Your convenience in making a todo list',
      'description':
          "Here's a mobile platform that helps you create task or to list so that it can help you in every job easier and faster.",
      'image': 'assets/images/Onboarding/first.png',
    },
    {
      'title': 'Find the practicality in making your todo list',
      'description':
          'Easy-to-understand user interface that makes you more comfortable when you want to create a task or to do list. Todyapp can also improve productivity.',
      'image': 'assets/images/Onboarding/second.png',
    },
    {
      'title': 'Gets Started with Todyapp',
      'description': '',
      'image': 'assets/images/Onboarding/third.png',
    },
  ];

  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemBuilder: (_, index) {
              final slide = slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      slide['image']!,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    if (slide['title']!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        slide['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        slide['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),

          // Skip Button
         Positioned(
              right: 16,
              top: 16,
              child: TextButton(
                onPressed: completeOnboarding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Skip',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),


          // Dots above the button
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 8,
                  width: currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xFF24A19C)
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Button at bottom
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex < slides.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  completeOnboarding();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF24A19C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  const SizedBox(width: 10),
                  Text(
                    currentIndex == slides.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}