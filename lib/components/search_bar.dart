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
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
