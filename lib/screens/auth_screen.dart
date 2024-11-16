import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campuslostandfound/screens/dashboard_screen.dart';
import 'package:campuslostandfound/services/google_auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _user = FirebaseAuth.instance.currentUser;

      if (_user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    });
  }

  // Sign In as Guest
  Future<void> _signInAsGuest() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        _user = userCredential.user;
      });
      print("Signed in as Guest successfully");
      _showMessage("Signed in as Guest");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    } catch (e) {
      print("Guest sign-in failed: $e");
      _showMessage("Sign-in failed. Please try again.");
    }
  }

  // Sign In with Google
  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCredential =
          await GoogleAuthService.signInWithGoogle();
      setState(() {
        _user = userCredential.user;
      });
      print("Signed in successfully: ${userCredential.user?.email}");
      _showMessage("Signed in as ${userCredential.user?.displayName}");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    } catch (e) {
      print("Google sign-in failed: $e");
      _showMessage("Sign-in failed. Please try again.");
    }
  }

  void _showMessage(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff000428), Color(0xff004e92)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Builder(
          builder: (context) {
            return Center(
              child: _user == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _signInAsGuest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xff004e92),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Sign in as Guest",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _signInWithGoogle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xff004e92),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Sign in with Google",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
