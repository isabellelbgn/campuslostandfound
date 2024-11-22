import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart' as blobs;

class ItemsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final VoidCallback? onBackButtonPressed;

  const ItemsAppBar({
    super.key,
    required this.child,
    this.onBackButtonPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -140,
          left: -60,
          child: BlobDecoration(
            size: MediaQuery.of(context).size.height * 0.3,
            color: const Color(0xFFE0E6F6),
          ),
        ),
        Positioned(
          bottom: -160,
          left: MediaQuery.of(context).size.width * 0.6,
          child: BlobDecoration(
            size: MediaQuery.of(context).size.height * 0.3,
            color: const Color(0xFF002EB0),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: child,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
              size: 25,
            ),
            onPressed: onBackButtonPressed,
          ),
        ),
      ],
    );
  }
}

class BlobDecoration extends StatelessWidget {
  final double size;
  final Color color;

  const BlobDecoration({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return blobs.Blob.fromID(
      id: const ['18-6-103'],
      size: size,
      styles: blobs.BlobStyles(color: color),
    );
  }
}
