import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/chatPage.dart';
import 'package:project/login_page.dart';
import 'package:project/signup_page.dart'; 
import 'firebase_options.dart';     
import 'package:firebase_auth/firebase_auth.dart'; 
import 'home_screen.dart';        
import 'second_page.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
    '/login': (context) => const LoginPage(),
    '/signup': (context) => const SignupPage(),
    '/chat': (context) => const ChatPage(),
  },
      debugShowCheckedModeBanner: false,
      // The StreamBuilder listens to Firebase. 
      // If a user exists, it shows HomeScreen. If not, it shows HomePage.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const SecondPage(); // User is logged in
          }
          return const HomePage(); // User is logged out
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "images/download.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Analyze your skin & get your perfect routine with AI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff501533),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecondPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Color(0xff501533),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
