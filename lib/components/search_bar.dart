import 'package:flutter/material.dart';

class SearchItemBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchItemBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search items...",
          hintStyle: TextStyle(color: Color(0xFFA8A8A8)),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFA8A8A8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFA8A8A8)),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
