import 'package:flutter/material.dart';

import 'presentation/app_flow.dart';

void main() {
  runApp(const BlueTalkApp());
}

class BlueTalkApp extends StatelessWidget {
  const BlueTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlueTalk',
      theme: blueTalkTheme(),
      home: const BlueTalkFlow(),
    );
  }
}
