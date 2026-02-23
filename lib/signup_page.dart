import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/second_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

final FirebaseAuth _auth = FirebaseAuth.instance;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // ADD THIS LINE
  bool isLoading = false; 

  Future<void> signUp() async {
    setState(() => isLoading = true);
    try {
  // 1. Create the Auth Account
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );

  // 2. Get the unique User ID (UID)
  String uid = userCredential.user!.uid;

  // 3. Save User Data to Firestore
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'uid': uid,
    'name': _nameController.text.trim(),
    'email': _emailController.text.trim(),
    'createdAt': DateTime.now(),
    'skinType': 'Unknown', // You can update this after the AI analysis!
  });

  // 4. Update the Auth Display Name (for the Welcome message)
  await userCredential.user?.updateDisplayName(_nameController.text.trim());

  if (mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SecondPage()), 
      (route) => false,
    );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 199, 215),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Full Name", fillColor: Colors.white, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "Email", fillColor: Colors.white, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Password", fillColor: Colors.white, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Sign Up"),
            ),
            const SizedBox(height: 20),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      "Already have an account? ",
      style: TextStyle(color: Colors.white70),
    ),
    GestureDetector(
      onTap: () {
        // If you came from SecondPage, pop takes you back there.
        // If you want to go DIRECTLY to Login:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text(
        "Login",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),
          ],
        ),
        
      ),
    );
  }
}