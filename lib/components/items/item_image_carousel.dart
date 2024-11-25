import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ItemCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ItemCarousel({super.key, required this.imageUrls});

  @override
  State<ItemCarousel> createState() => _ItemCarouselState();
}

class _ItemCarouselState extends State<ItemCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.imageUrls.map((url) {
            return Image.network(
              url,
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
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => setState(() {
                _currentIndex = entry.key;
              }),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? const Color(0xFF002EB0)
                      : const Color(0xFFB0B0B0),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
