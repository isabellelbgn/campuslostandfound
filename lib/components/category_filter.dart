import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
      scrollDirection: Axis.horizontal,
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
      child: SizedBox(
        width: 100,
        height: 150,
        child: ElevatedButton(
          onPressed: () {
            onCategorySelected(category);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 20),
            backgroundColor: selectedCategory == category
                ? const Color(0xFF002EB0)
                : const Color(0xFFE0E0E0),
            foregroundColor: selectedCategory == category
                ? Colors.white
                : const Color(0xFFA8A8A8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AutoSizeText(
                category,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
