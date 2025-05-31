import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todyapp Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
              
                Navigator.pushNamed(context, '/onboarding');
              },
              child: Text('Onboarding Screen'),
            ),
            Text('This is the Home Page', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
