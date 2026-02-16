import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bluetalk.')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('About',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                SizedBox(height: 12),
                Text('Terms and Condition',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('Last updated: January 14, 2026',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text(
                  'Welcome to bluetalk. By accessing or using this mobile application, '
                  'you agree to be bound by these Terms and Conditions.',
                  style: TextStyle(height: 1.45, fontSize: 18),
                ),
                SizedBox(height: 18),
                Text('1. Purpose of the App',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text(
                  'bluetalk is designed to help users communicate with nearby users offline. '
                  'This app is not intended to provide medical, psychological, or professional services.',
                  style: TextStyle(height: 1.45, fontSize: 18),
                ),
                SizedBox(height: 16),
                Text('2. Not a Medical Service',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text(
                    '• The app does not diagnose, treat, or prevent any mental health condition.',
                    style: TextStyle(fontSize: 18)),
                Text('• Content provided is for self-reflection only.',
                    style: TextStyle(fontSize: 18)),
                Text(
                  '• If you are experiencing severe distress, please seek help from a licensed professional or emergency services.',
                  style: TextStyle(height: 1.4, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
