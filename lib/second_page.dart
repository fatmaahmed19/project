import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'chatPage.dart'; // تأكدي إنك عملتي الملف ده بنفس الاسم

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  final Color primaryBurgundy = const Color(0xFF8E4461); 
  final Color softPinkBg = const Color(0xFFFDEEF4); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPinkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. الأزرار العلوية (Sign in / Log in)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          _buildSmallButton(
                            context, 
                            "Sign in", 
                            Colors.white, 
                            primaryBurgundy, 
                            isBordered: true,
                            targetPage: const SignupPage(),
                          ),
                          const SizedBox(width: 10),
                          _buildSmallButton(
                            context, 
                            "Log in", 
                            Colors.white, 
                            primaryBurgundy, 
                            isBordered: true,
                            targetPage: const LoginPage(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // 2. النصوص الترحيبية
                Text(
                  "Smart Skin.\nSmarter Care.",
                  style: TextStyle(
                    color: primaryBurgundy,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Personalized routines in seconds.",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),

                const SizedBox(height: 40),

                // 3. كارت الـ Skin Analyzer
                _buildFeatureCard(
                  context,
                  "Skin Analyzer",
                  "Scan your skin to detect and analyze any issues",
                  Icons.face_retouching_natural,
                  onTap: () {
                    print("Skin Analyzer Tapped");
                  },
                ),
                
                const SizedBox(height: 20),

                // 4. كارت الـ SkinCare Bot (اللي بيفتح الشات)
                _buildFeatureCard(
                  context,
                  "SkinCare Bot",
                  "Get personalized routines from our AI assistant",
                  Icons.smart_toy_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  },
                ),
                
                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    "How It Works",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 5),
                const Center(
                  child: Text(
                    "3 simple steps to smarter skincare :",
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton(BuildContext context, String text, Color bgColor, Color textColor, {required bool isBordered, required Widget targetPage}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isBordered ? Border.all(color: primaryBurgundy) : null,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: softPinkBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: primaryBurgundy, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: primaryBurgundy),
          ],
        ),
      ),
    );
  }
}