import 'dart:async';
import 'package:campuslostandfound/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  StreamSubscription<User?>? _authStateListener;

  AuthState() {
    _authStateListener =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signInAsGuest(BuildContext context) async {
    setLoading(true);
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        if (context.mounted) {
          _showMessage(context, "Signed in as Guest");
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (context.mounted) {
          _showMessage(context, "Sign-in failed. Please try again.");
        }
      }
    } on FirebaseAuthException {
      if (context.mounted) {
        _showMessage(context, "Sign-in failed. Please try again.");
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      final userCredential = await GoogleAuthService.signInWithGoogle();
      if (context.mounted) {
        _showMessage(
            context, "Signed in as ${userCredential.user?.displayName}");
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException {
      if (context.mounted) {
        _showMessage(context, "Sign-in failed. Please try again.");
      }
    } finally {
      setLoading(false);
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _authStateListener?.cancel();
    super.dispose();
  }
}
