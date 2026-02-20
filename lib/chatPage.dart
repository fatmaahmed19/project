import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون الخلفية بينك رقيق
      backgroundColor: const Color(0xFFFDEEF4), 
      appBar: AppBar(
        title: const Text("Chat Bot"),
        backgroundColor: const Color(0xFF8E4461), // لون الـ AppBar بورجوندي
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          "Hellooo ✨",
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF8E4461),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}