import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF002EB0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
    );
  }
}
