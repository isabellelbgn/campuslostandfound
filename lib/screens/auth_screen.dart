import 'dart:async';
import 'package:campuslostandfound/components/auth_app_bar.dart';
import 'package:campuslostandfound/components/auth_google_button.dart';
import 'package:campuslostandfound/components/auth_guest_button.dart';
import 'package:campuslostandfound/screens/dashboard_screen.dart';
import 'package:campuslostandfound/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _signInAsGuest() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final user = userCredential.user;

      if (mounted) {
        if (user != null) {
          _showMessage("Signed in as Guest");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        } else {
          _showMessage("Sign-in failed. Please try again.");
        }
      }
    } on FirebaseAuthException {
      if (mounted) {
        _showMessage("Sign-in failed. Please try again.");
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final userCredential = await GoogleAuthService.signInWithGoogle();

      if (mounted) {
        _showMessage("Signed in as ${userCredential.user?.displayName}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    } on FirebaseAuthException {
      if (mounted) {
        _showMessage("Sign-in failed. Please try again.");
      }
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
      appBar: const CustomAppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App name
              const Text(
                'FoundIt!',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002EB0),
                ),
              ),
              const SizedBox(height: 30),

              // Google sign-in button
              SignInButton(onPressed: _signInWithGoogle),
              const SizedBox(height: 20),

              // Guest access button
              GuestSignInButton(onPressed: _signInAsGuest),
            ],
          ),
        ),
      ),
    );
  }
}
