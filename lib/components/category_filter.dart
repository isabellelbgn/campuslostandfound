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
          _categoryFilterButton("Accessories"),
          _categoryFilterButton("Bags"),
          _categoryFilterButton("Identification"),
          _categoryFilterButton("Personal Items"),
          _categoryFilterButton("Electronics"),
          _categoryFilterButton("Clothing"),
          _categoryFilterButton("Books"),
          _categoryFilterButton("Stationary"),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "All":
        return Icons.category;
      case "Accessories":
        return Icons.watch;
      case "Bags":
        return Icons.shopping_bag;
      case "Identification":
        return Icons.badge;
      case "Personal Items":
        return Icons.person;
      case "Electronics":
        return Icons.devices;
      case "Clothing":
        return Icons.checkroom;
      case "Books":
        return Icons.book;
      case "Stationary":
        return Icons.create;
      default:
        return Icons.help_outline;
    }
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
            padding: EdgeInsets.symmetric(vertical: 10),
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
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 36),
                child: Icon(
                  _getCategoryIcon(category),
                  size: 30.0,
                ),
              ),
              Column(
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
            ],
          ),
        ),
      ),
    );
  }
}
