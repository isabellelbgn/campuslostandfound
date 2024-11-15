import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _categoryFilterButton("All"),
          _categoryFilterButton("Electronics"),
          _categoryFilterButton("Clothing"),
          _categoryFilterButton("Books"),
          _categoryFilterButton("Accessories"),
        ],
      ),
    );
  }

  Widget _categoryFilterButton(String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          onCategorySelected(category);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category
              ? Colors.blue[900]
              : Colors.grey[300],
          foregroundColor:
              selectedCategory == category ? Colors.white : Colors.black,
        ),
        child: Text(category),
      ),
    );
  }
}
