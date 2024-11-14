import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  User? _user;

  // Sign In
  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCredential = await signInWithGoogle();
      setState(() {
        _user = userCredential.user;
      });
      print("Signed in successfully: ${userCredential.user?.email}");
      _showMessage("Signed in as ${userCredential.user?.displayName}");
    } catch (e) {
      print("Google sign-in failed: $e");
      _showMessage("Sign-in failed. Please try again.");
    }
  }

  // Sign out
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
    });
    _showMessage("Signed out successfully.");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign-In Test"),
      ),
      body: Center(
        child: _user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: const Text("Sign in with Google"),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Signed in as: ${_user?.displayName ?? 'Unknown'}"),
                  Text("Email: ${_user?.email ?? 'No Email'}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text("Sign Out"),
                  ),
                ],
              ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
