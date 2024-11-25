import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart';

class BlobBackground extends StatelessWidget {
  const BlobBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          left: -100,
          child: Blob.fromID(
            id: const ['18-6-103'],
            size: 400,
            styles: BlobStyles(color: const Color(0xFFE0E6F6)),
          ),
        ),
        Positioned(
          top: -150,
          left: -100,
          child: Blob.fromID(
            id: const ['6-6-54'],
            size: 400,
            styles: BlobStyles(color: const Color(0xFF002EB0)),
          ),
        ),
        Positioned(
          top: 200,
          right: -280,
          bottom: 200,
          child: Blob.fromID(
            id: const ['6-2-33005'],
            size: 400,
            styles: BlobStyles(color: const Color(0xFF002EB0)),
          ),
        ),
        Positioned(
          bottom: -150,
          right: -100,
          child: Blob.fromID(
            id: const ['4-5-4980'],
            size: 400,
            styles: BlobStyles(color: const Color(0xFFE0E6F6)),
          ),
        ),
      ],
    );
  }
}
