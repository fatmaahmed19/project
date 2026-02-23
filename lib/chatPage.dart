import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Color primaryBurgundy = const Color(0xFF8E4461);
  final Color softPinkBg = const Color(0xFFFDEEF4);
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  bool isPregnant = false;
  bool hasRosacea = false;
  bool isSensitive = false;
  bool hasAcne = false;
  String blackheadsLevel = "Low";
  String morningRoutine = "";
  String nightRoutine = "";
  String routineWarnings = "";

  final List<Map<String, dynamic>> _allQuestions = [
    {
      "id": "blackheads",
      "question": "How would you describe your blackheads?",
      "options": ["Low", "Medium", "High"],
    },
    {
      "id": "sensitive",
      "question": "Is your skin generally sensitive?",
      "options": ["Yes", "No"],
    },
    {
      "id": "acne",
      "question": "Do you have active inflamed acne/pimples?",
      "options": ["Yes", "No"],
    },
    {
      "id": "pregnant",
      "question": "Are you currently pregnant or nursing?",
      "options": ["Yes", "No"],
    },
    {
      "id": "rosacea",
      "question": "Do you have Rosacea (persistent redness)?",
      "options": ["Yes", "No"],
    },
  ];

  int _currentQuestionIndex = 0;
  bool _isChatFinished = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(_allQuestions[_currentQuestionIndex]["question"]);
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add({"sender": "bot", "text": text, "isQuestion": true});
    });
    _scrollToBottom();
  }

  void _handleUserSelection(String choice) async {
    String qId = _allQuestions[_currentQuestionIndex]["id"];

    if (qId == "pregnant") isPregnant = (choice == "Yes");
    if (qId == "rosacea") hasRosacea = (choice == "Yes");
    if (qId == "sensitive") isSensitive = (choice == "Yes");
    if (qId == "acne") hasAcne = (choice == "Yes");
    if (qId == "blackheads") blackheadsLevel = choice;

    setState(() {
      _messages.add({"sender": "user", "text": choice, "isQuestion": false});
      _messages[_messages.length - 2]["isQuestion"] = false;
      _isTyping = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isTyping = false);
      if (_currentQuestionIndex < _allQuestions.length - 1) {
        _currentQuestionIndex++;
        _addBotMessage(_allQuestions[_currentQuestionIndex]["question"]);
      } else {
        _generateSmartRoutine();
      }
    }
  }

  void _generateSmartRoutine() {
    // خطوات أساسية ثابتة لكل الحالات
    List<String> morningSteps = ["Gentle Cleanser", "Niacinamide Serum"];
    List<String> nightSteps = ["Double Cleansing (Oil + Water)", "Moisturizer"];
    List<String> warningsList = [];

    // --- 1. معالجة الرؤوس السوداء (The Blackheads Engine) ---
    if (blackheadsLevel == "High") {
      // علاج مكثف للبلاك هيدز
      if (!isPregnant && !isSensitive && !hasRosacea) {
        nightSteps.insert(1, "BHA / Salicylic Acid 2% (3 times/week)");
      } else {
        // لو الحالة حساسة أو حامل، بنستخدم بديل ألطف أو وتيرة أقل
        nightSteps.insert(1, "Gentle BHA or Lactic Acid (Once a week)");
      }
    } else if (blackheadsLevel == "Medium") {
      nightSteps.insert(1, "BHA / Salicylic Acid (2 times/week)");
    }

    // --- 2. معالجة الحالات الخاصة (Pregnancy, Sensitivity, Rosacea) ---

    // الحالة أ: الحمل (الأولوية للأمان)
    if (isPregnant) {
      nightSteps.insert(
        nightSteps.length - 1,
        "Azelaic Acid (Safe for Pregnancy & Acne)",
      );
      warningsList.add(
        "⚠️ Retinol and strong chemical exfoliants are removed for baby safety.",
      );
    } else {
      // الحالة ب: لو مش حامل (الرتينول هو الملك)
      if (isSensitive || hasRosacea) {
        nightSteps.insert(
          nightSteps.length - 1,
          "Gentle Retinoid or Bakuchiol (Start slowly)",
        );
      } else {
        nightSteps.insert(
          nightSteps.length - 1,
          "Retinol (Start 2-3 times/week)",
        );
      }
    }

    // الحالة ج: البشرة الحساسة أو الـ Rosacea
    if (isSensitive || hasRosacea) {
      morningSteps.add("Soothing Cream (Panthenol)");
      warningsList.add(
        "⚠️ Avoid physical scrubs and high-concentration Acids.",
      );
    }

    // الحالة د: الحبوب النشطة (Inflamed Acne)
    if (hasAcne) {
      if (isSensitive || isPregnant) {
        morningSteps.add("Azelaic Acid (Spot treatment for inflammation)");
      } else {
        morningSteps.add("Benzoyl Peroxide (Spot treatment on pimples)");
      }
    }

    // الخطوة الأخيرة في الصبح دايماً ثابتة
    morningSteps.add("Lightweight Sunscreen SPF 50");

    setState(() {
      morningRoutine = morningSteps.map((s) => "• $s").join("\n");
      nightRoutine = nightSteps.map((s) => "• $s").join("\n");
      routineWarnings = warningsList.join("\n");
    });

    _showResultOverlay(morningRoutine, nightRoutine, routineWarnings);
  }

  /*
  void _handleSaveRequest(String morning, String night, String warnings) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // No user signed in - Show the prompt
      _showAuthRequiredDialog();
    } else {
      // User is signed in - Proceed to save
      _saveRoutineToFirestore(morning, night, warnings, user.uid);
    }
  }

  void _showAuthRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Save Your Routine",
          style: TextStyle(color: primaryBurgundy),
        ),
        content: const Text(
          "You need an account to save and track your skincare progress. Would you like to sign in now?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Maybe Later",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Replace 'LoginPage' with your actual Login route name
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy),
            child: const Text(
              "Sign In / Sign Up",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }*/

  void _showLoginRequiredAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Icon(Icons.lock_outline_rounded, color: primaryBurgundy, size: 50),
            const SizedBox(height: 15),
            Text(
              "Sign In Required",
              style: TextStyle(
                color: primaryBurgundy,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          "To save your personalized routine and access it later, you need to be part of the community!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/login',
                  ), // Update with your route
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBurgundy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/signup',
                ), // Update with your route
                child: Text(
                  "Create an account",
                  style: TextStyle(color: primaryBurgundy),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Maybe Later",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSavePressed(String morning, String night, String warnings) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // 🛑 No user found: Trigger the alert
      _showLoginRequiredAlert();
    } else {
      // ✅ User exists: Save to Firestore
      _saveRoutineToFirestore(morning, night, warnings, user.uid);
    }
  }

  Future<void> _saveRoutineToFirestore(
    String morning,
    String night,
    String warnings,
    String uid,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('user_routines').add({
        'ownerId': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'morning': morning,
        'night': night,
        'warnings': warnings,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✨ Routine secured in your profile!")),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showResultOverlay(String morning, String night, String warnings) {
    String chatSummary =
        "✨ ANALYSIS COMPLETE:\n\n☀️ MORNING:\n$morning\n\n🌙 NIGHT:\n$night\n${warnings.isNotEmpty ? '\n$warnings' : ''}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "✨ Expert Routine",
                  style: TextStyle(
                    color: primaryBurgundy,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildRoutineBox("☀️ Morning", morning, Colors.orange.shade50),
                const SizedBox(height: 10),
                _buildRoutineBox("🌙 Night", night, Colors.indigo.shade50),
                if (warnings.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      warnings,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      
                      Future.microtask(() {
                        _onSavePressed(
                          morningRoutine,
                          nightRoutine,
                          routineWarnings,
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBurgundy,
                    ),
                    child: const Text(
                      "Save My Routine",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineBox(String title, String content, Color bgColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryBurgundy,
            ),
          ),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPinkBg,
      appBar: AppBar(
        title: const Text("SkinCare Assistant"),
        backgroundColor: Colors.white,
        foregroundColor: primaryBurgundy,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping)
                  return _buildTypingIndicator();
                var msg = _messages[index];
                bool isBot = msg["sender"] == "bot";
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: isBot
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isBot)
                        _buildAvatar(
                          Icons.smart_toy_rounded,
                          Colors.white,
                          primaryBurgundy,
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: _buildChatBubble(
                          msg["text"],
                          isBot,
                          isBot && msg["isQuestion"] == true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!isBot)
                        _buildAvatar(
                          Icons.person_rounded,
                          primaryBurgundy,
                          Colors.white,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          /*if (_isChatFinished)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  _onSavePressed(morningRoutine, nightRoutine, routineWarnings);
                },
                icon: const Icon(Icons.home_filled),
                label: const Text("Save My Routine"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBurgundy,
                ),
              ),
            ),*/
        ],
      ),
    );
  }

  Widget _buildAvatar(IconData icon, Color bg, Color iconC) => Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: bg,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
    ),
    child: Icon(icon, color: iconC, size: 20),
  );

  Widget _buildChatBubble(String text, bool isBot, bool showOptions) {
    return Column(
      crossAxisAlignment: isBot
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isBot ? Colors.white : primaryBurgundy,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isBot ? 0 : 20),
              bottomRight: Radius.circular(isBot ? 20 : 0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isBot ? Colors.black87 : Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        if (showOptions && !_isTyping)
          _buildOptions(_allQuestions[_currentQuestionIndex]["options"]),
      ],
    );
  }

  Widget _buildOptions(List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options
            .map(
              (opt) => InkWell(
                onTap: () => _handleUserSelection(opt),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryBurgundy.withOpacity(0.2)),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: primaryBurgundy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTypingIndicator() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        _buildAvatar(Icons.smart_toy_rounded, Colors.white, primaryBurgundy),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            "...",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
