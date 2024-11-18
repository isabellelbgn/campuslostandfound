import 'dart:async';
import 'package:campuslostandfound/components/auth_app_bar.dart';
import 'package:campuslostandfound/components/auth_google_button.dart';
import 'package:campuslostandfound/components/auth_guest_button.dart';
import 'package:campuslostandfound/screens/dashboard_screen.dart';
import 'package:campuslostandfound/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> _signInAsGuest(BuildContext context) async {
    try {
      _showMessage(context, "Signed in as Guest");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } on FirebaseAuthException {
      _showMessage(context, "Sign-in failed. Please try again.");
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final userCredential = await GoogleAuthService.signInWithGoogle();
      _showMessage(context, "Signed in as ${userCredential.user?.displayName}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } on FirebaseAuthException {
      _showMessage(context, "Sign-in failed. Please try again.");
    }
  }

  void _showMessage(BuildContext context, String message) {
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
              SignInButton(onPressed: () => _signInWithGoogle(context)),
              const SizedBox(height: 20),

              // Guest access button
              GuestSignInButton(onPressed: () => _signInAsGuest(context)),
            ],
          ),
        ),
      ),
    );
  }
}
