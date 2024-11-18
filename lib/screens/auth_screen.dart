import 'package:campuslostandfound/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campuslostandfound/screens/dashboard_screen.dart';
import 'package:campuslostandfound/services/google_auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Color(0xFF002EB0)),
              label: const Text(
                "Go Back",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF002EB0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Builder(
                builder: (context) {
                  return Center(
                    child: _user == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _signInAsGuest,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF002EB0),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.solidUser,
                                    size: 15,
                                  ),
                                  label: const Text(
                                    "Sign in as Guest",
                                    style: TextStyle(
                                      fontSize: 16,
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
                                    backgroundColor: const Color(0xFF002EB0),
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
                                      fontSize: 16,
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
          ],
        ),
      ),
    );
  }
}
