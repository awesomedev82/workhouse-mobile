import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workhouse/components/web_view_screen.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({Key? key}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<Map<String, String>> imageCards = [
    {
      'image': 'assets/images/carousel-4.png',
      'url': 'https://digitalpark.studio/',
      'title': 'WorkHouse'
    },
    {
      'image': 'assets/images/carousel-5.png',
      'url': 'https://tally.so/r/w5qAWd',
      'title': 'WorkHouse'
    },
    {
      'image': 'assets/images/carousel-6.png',
      'url': 'https://tally.so/r/woVjXV',
      'title': 'WorkHouse'
    },
    {
      'image': 'assets/images/carousel-4.png',
      'url': 'https://digitalpark.studio/',
      'title': 'WorkHouse'
    },
    {
      'image': 'assets/images/carousel-5.png',
      'url': 'https://tally.so/r/w5qAWd',
      'title': 'WorkHouse'
    },
    {
      'image': 'assets/images/carousel-6.png',
      'url': 'https://tally.so/r/woVjXV',
      'title': 'WorkHouse'
    },
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            FlutterCarousel(
              options: CarouselOptions(
                height: 180.0,
                aspectRatio: 1,
                showIndicator: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                disableCenter: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: imageCards.map((card) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          url: card['url']!,
                          title: card['title']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(card['image']!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imageCards.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: index == _current
                          ? Color(0xFFAAD130)
                          : Color(0xFF4D4D4D),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        if (_current == 2 || _current == 5)
          Positioned(
            top: 10,
            right: 30,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              decoration: BoxDecoration(
                color: Color(0xFFAAD130),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Ad',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        Positioned(
          bottom: 40,
          left: 40,
          child: SvgPicture.asset(
            "assets/images/logo.svg",
            height: 25,
          ),
        ),
      ],
    );
  }
}
