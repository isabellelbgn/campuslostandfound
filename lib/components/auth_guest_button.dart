import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GuestSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GuestSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF002EB0),
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.solidUser,
          size: 15,
        ),
        label: const Text(
          "Access as Guest",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
