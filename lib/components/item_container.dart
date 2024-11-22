import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 315,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.item['imageUrl'] != null
                      ? Image.network(
                          widget.item['imageUrl'] is List
                              ? (widget.item['imageUrl'] as List<dynamic>).first
                              : widget.item['imageUrl'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: SpinKitChasingDots(
                                  color: Color(0xFF002EB0),
                                  size: 50.0,
                                ),
                              );
                            }
                          },
                        )
                      : const Text('No Image Available'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.item['name'] ?? 'No Name',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF002EB0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.item['location'] ?? 'No Location',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Color(0xFF525660),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFCCD5EF),
              ),
              child: Text(
                widget.item['status'] ?? 'No Status',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002EB0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
