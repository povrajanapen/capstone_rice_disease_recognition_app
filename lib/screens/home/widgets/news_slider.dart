import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../dummy_data/dummy_data.dart';

class NewsSlider extends StatelessWidget {
  const NewsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200, // Adjust height as needed
        autoPlay: true, // Enables automatic sliding
        autoPlayInterval: const Duration(seconds: 3), // Change slide every 3 sec
        autoPlayAnimationDuration: const Duration(milliseconds: 800), // Smooth transition
        enlargeCenterPage: true, // Slightly enlarges active slide
        viewportFraction: 0.9, // Adjust how much of the next slides are visible
      ),
      items: sliderContent.map((slide) {
        return _buildSlide(slide);
      }).toList(),
    );
  }
}

Widget _buildSlide(SlideContent slide) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: Colors.grey.shade200);
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(slide.title, style:  RiceTextStyles.body.copyWith(color: Colors.white)),
              Text(slide.subtitle, style:  TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ],
    ),
  );
}

class SlideContent {
  final String image;
  final String title;
  final String subtitle;

  SlideContent({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

