import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearch;

  const SearchInput({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Search items...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => onSearch(),
        ),
      ],
    );
  }
}
