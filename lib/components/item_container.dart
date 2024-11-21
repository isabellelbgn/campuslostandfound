import 'package:flutter/material.dart';

class ItemContainer extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const ItemContainer({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.item['imageUrl'] != null
                  ? Image.network(
                      widget.item['imageUrl'] is List
                          ? (widget.item['imageUrl'] as List<dynamic>).first
                          : widget.item['imageUrl'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Text('No Image Available'),
              const SizedBox(height: 15),
              Text(
                widget.item['name'] ?? 'No Name',
                style: TextStyle(
                  fontSize: 16,
                  color: _isHovered
                      ? const Color(0xFF002EB0)
                      : Colors.grey, // Hover effect
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.item['description'] ?? 'No Description',
                style: TextStyle(
                  fontSize: 14,
                  color: _isHovered
                      ? const Color(0xFF002EB0)
                      : Colors.grey, // Hover effect
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.item['location'] ?? 'No Location',
                style: TextStyle(
                  fontSize: 14,
                  color: _isHovered
                      ? const Color(0xFF002EB0)
                      : Colors.grey, // Hover effect
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
