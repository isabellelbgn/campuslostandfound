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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Builder(
          builder: (context) {
            return Center(
              child: _user == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signInAsGuest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF002EB0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            child: const Text(
                              "Sign in as Guest",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _signInWithGoogle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF002EB0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            icon: Image.network(
                              'https://cdn-icons-png.freepik.com/256/16509/16509564.png?semt=ais_hybrid',
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                            ),
                            label: const Text(
                              "Sign in with Google",
                              style: TextStyle(
                                fontSize: 18,
                              ),
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
