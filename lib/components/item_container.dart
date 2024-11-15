import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const ItemContainer({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        // Item Container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item['imageUrl'] != null
                ? Image.network(
                    item['imageUrl'] is List
                        ? (item['imageUrl'] as List<dynamic>).first
                        : item['imageUrl'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Text('No Image Available'),
            const SizedBox(height: 8),
            Text(
              item['name'] ?? 'No Name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['description'] ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              item['location'] ?? 'No Location',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
