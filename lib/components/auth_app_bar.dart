import 'package:flutter/material.dart';
import 'package:campuslostandfound/main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF002EB0)),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        },
      ),
    );
  }
}
