import 'dart:async';
import 'package:campuslostandfound/components/auth_google_button.dart';
import 'package:campuslostandfound/components/auth_guest_button.dart';
import 'package:campuslostandfound/screens/dashboard_screen.dart';
import 'package:campuslostandfound/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'services/firebase_options.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _authStateListener?.cancel();
    super.dispose();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FoundIt!',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Montserrat',
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    if (authState.user != null) {
      return const Dashboard();
    } else {
      return const MyHomePage();
    }
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return Scaffold(
      body: authState.isLoading
          ? const Center(
              child: SpinKitChasingDots(
                color: Color(0xFF002EB0),
                size: 50.0,
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: -120,
                    left: -100,
                    child: Blob.fromID(
                      id: const ['18-6-103'],
                      size: 400,
                      styles: BlobStyles(
                        color: const Color(0xFFE0E6F6),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -150,
                    left: -100,
                    child: Blob.fromID(
                      id: const ['6-6-54'],
                      size: 400,
                      styles: BlobStyles(
                        color: const Color(0xFF002EB0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    right: -280,
                    bottom: 200,
                    child: Blob.fromID(
                      id: const ['6-2-33005'],
                      size: 400,
                      styles: BlobStyles(
                        color: const Color(0xFF002EB0),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -150,
                    right: -100,
                    child: Blob.fromID(
                      id: const ['4-5-4980'],
                      size: 400,
                      styles: BlobStyles(
                        color: const Color(0xFFE0E6F6),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/assets/icons/logo.png',
                            height: 100,
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text.rich(
                              TextSpan(
                                text: 'Your Go-To App for Lost and Found at ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF002EB0),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Ateneo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 100),
                          SignInButton(
                            onPressed: () =>
                                authState.signInWithGoogle(context),
                          ),
                          const SizedBox(height: 15),
                          const SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          GuestSignInButton(
                            onPressed: () => authState.signInAsGuest(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
