import 'dart:async';
import 'package:campuslostandfound/components/auth/auth_google_button.dart';
import 'package:campuslostandfound/components/auth/auth_guest_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'services/firebase_options.dart';
import 'services/auth_state.dart';
import 'components/blob_background.dart';
import 'screens/dashboard_screen.dart';
import 'screens/items_screen.dart';
import 'screens/message_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
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
        routes: {
          '/': (context) => const AuthWrapper(),
          '/home': (context) => const Dashboard(),
          '/items': (context) => const SeeAllItemsPage(),
          '/messages': (context) => const MessageScreen(),
        },
        initialRoute: '/',
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
                  const BlobBackground(),
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
