import 'package:blobs/blobs.dart' as blobs;
import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double blobSize;
  final VoidCallback onMenuPressed;

  const DashboardAppBar({
    super.key,
    required this.blobSize,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          top: -140,
          left: -60,
          child: blobs.Blob.fromID(
            id: const ['18-6-103'],
            size: blobSize,
            styles: blobs.BlobStyles(
              color: const Color(0xFFE0E6F6),
            ),
          ),
        ),
        Positioned(
          bottom: -160,
          left: screenWidth * 0.6,
          child: blobs.Blob.fromID(
            id: const ['18-6-103'],
            size: blobSize,
            styles: blobs.BlobStyles(
              color: const Color(0xFF002EB0),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'lib/assets/icons/logo.png',
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: onMenuPressed,
          ),
        ),
      ],
    );
  }
}
