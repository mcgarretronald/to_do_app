import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          Text('Login Page'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }, 
            child: Text('Back Home'))
        ],
      ),
    );
  }
}