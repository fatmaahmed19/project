import 'package:flutter/material.dart';
import 'dart:ui'; // Required for Glassmorphism blur
import 'login_page.dart';
import 'signup_page.dart';
import 'chatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final Color primaryBurgundy = const Color(0xFF8E4461);
  final Color softPinkBg = const Color(0xFFFDEEF4);

  // Track which "How It Works" step is expanded. Default to middle (index 1).
  int _activeStepIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPinkBg,
      body: Container(
        // Added a slight gradient to the background to make glassmorphism pop
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [softPinkBg, const Color(0xFFFFE4EE)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Dynamic User Header
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        final User? user = snapshot.data;
                        final bool isLoggedIn = user != null;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // User Icon and Name
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person, color: Colors.grey),
                                ),
                                if (isLoggedIn) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    "Hi, ${user.displayName ?? 'User'}", // Shows name or 'User' if name is null
                                    style: TextStyle(
                                      color: primaryBurgundy,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // Login/Signup buttons OR Logout button
                            Row(
                              children: [
                                if (!isLoggedIn) ...[
                                  _buildSmallButton(
                                    context,
                                    "Sign up",
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
                                ] else ...[
                                  // Logout Button
                                  IconButton(
                                    onPressed: () =>
                                        FirebaseAuth.instance.signOut(),
                                    icon: Icon(
                                      Icons.logout,
                                      color: primaryBurgundy,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 50),

                  // 2. Greeting Text
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

                  // 3. Feature Cards
                  _buildFeatureCard(
                    context,
                    "Skin Analyzer",
                    "Scan your skin to detect and analyze any issues",
                    Icons.face_retouching_natural,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    "SkinCare Bot",
                    "Get personalized routines from our AI assistant",
                    Icons.smart_toy_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // 4. "How It Works" Section
                  const Center(
                    child: Text(
                      "How It Works",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "3 simple steps to smarter skincare :",
                      style: TextStyle(color: Colors.black45, fontSize: 17),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // --- MAGNIFYING CONTAINERS START HERE ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // Aligns bottoms
                    children: [
                      _buildStepCard(
                        0,
                        "Step 1",
                        "Choose Your\nPath",
                        "Choose how you’d like to begin: \n 📸 Snap a photo for instant scan 💬 Or answer a few guided questions",
                      ),
                      _buildStepCard(
                        1,
                        "Step 2",
                        "We Understand \n Your Skin",
                        " Our system studies your skin conditionand identifies what truly needs attention — \n gently and accurately.",
                      ),
                      _buildStepCard(
                        2,
                        "Step 3",
                        "Get Your\nRoutine",
                        "Receive a routine tailored just for you safe, simple, and designed to improve your skin step by step.",
                      ),
                    ],
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper for the Magnifying Glassmorphism Cards
  Widget _buildStepCard(int index, String step, String title, String desc) {
    bool isSelected = _activeStepIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _activeStepIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        // Use easeOutBack for a "popping" effect or easeInOutCubic for smooth luxury
        curve: Curves.easeOutBack,
        width: isSelected ? 270 : 150,
        height: isSelected ? 470 : 300,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withOpacity(isSelected ? 0.8 : 0.3),
                  width: isSelected ? 2 : 1,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(isSelected ? 0.5 : 0.15),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      step,
                      style: TextStyle(
                        color: primaryBurgundy,
                        fontSize: isSelected ? 16 : 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: isSelected ? 19 : 14,
                        color: Colors.black87,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: isSelected ? 40 : 25),
                    // The Glowing Icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: isSelected ? 70 : 50,
                      width: isSelected ? 70 : 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.3),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        index == 0
                            ? Icons.camera_alt
                            : (index == 1
                                  ? Icons.psychology
                                  : Icons.auto_awesome),
                        color: primaryBurgundy.withOpacity(0.8),
                        size: isSelected ? 40 : 28,
                      ),
                    ),
                    SizedBox(height: isSelected ? 30 : 0),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: isSelected ? 1.0 : 0.0,
                      child: isSelected
                          ? Text(
                              desc,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Your existing helper methods
  Widget _buildSmallButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor, {
    required bool isBordered,
    required Widget targetPage,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isBordered ? Border.all(color: primaryBurgundy) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
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
