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
  final List<String> imageSources = [
    'assets/images/carousel-1.png',
    'assets/images/carousel-2.png',
    'assets/images/carousel-3.png',
    'assets/images/carousel-1.png',
    'assets/images/carousel-2.png',
    'assets/images/carousel-3.png',
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
                slideIndicator: CircularSlideIndicator(),
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                disableCenter: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: [0, 1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to WebViewScreen when the image is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WebViewScreen(url: 'https://www.google.com'),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imageSources[i]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...[0, 1, 2, 3, 4, 5].map((val) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: val == _current
                            ? Color(0xFFAAD130)
                            : Color(0xFF4D4D4D),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 20,
          right: 40,
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: Color(0xFFAAD130),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Ad',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        Positioned(
            bottom: 40,
            left: 40,
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              height: 25,
            )),
      ],
    );
  }
}
