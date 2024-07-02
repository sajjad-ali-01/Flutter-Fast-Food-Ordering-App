import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  final List<String> _imageUrls = [
    'assets/images/H1.jpg',
    'assets/images/H2.jpg',
    'assets/images/H3.jpg',
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 130,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) {
              if (mounted) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          ),
          items: _imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Image.asset(imageUrl, fit: BoxFit.cover, width: double.infinity);
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10.0),
        DotsIndicator(
          dotsCount: _imageUrls.length,
          position: _currentIndex.toDouble(),
          decorator: DotsDecorator(
            activeColor: Colors.red,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }
}