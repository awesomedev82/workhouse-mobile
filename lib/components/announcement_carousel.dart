import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:workhouse/components/app_video_player.dart';

class AnnouncementCarousel extends StatefulWidget {
  const AnnouncementCarousel({Key? key, this.height, required this.data})
      : super(key: key);
  final List<dynamic> data;
  final double? height;

  @override
  _AnnouncementCarouselState createState() => _AnnouncementCarouselState();
}

class _AnnouncementCarouselState extends State<AnnouncementCarousel> {
  final List<String> imageSources = [
    'assets/images/carousel-1.png',
    'assets/images/carousel-2.png',
    'assets/images/carousel-3.png',
    'assets/images/carousel-1.png',
    'assets/images/carousel-2.png',
    'assets/images/carousel-3.png',
  ];

  late List<int> indexList = <int>[];

  @override
  void initState() {
    super.initState();
    indexList = List.generate(widget.data.length, (index) => index);
  }

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FlutterCarousel(
            options: CarouselOptions(
              height: widget.height ?? 180.0,
              aspectRatio: 1,
              showIndicator: false,
              slideIndicator: CircularSlideIndicator(),
              autoPlay: false,
              disableCenter: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: indexList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.data[i]["type"] == "image"
                            ? Image.network(
                                widget.data[i]["url"],
                                fit: BoxFit.cover,
                              )
                            : AppVideoPlayer(
                                sourceURL: widget.data[i]["url"],
                              ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          indexList.length > 1
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...indexList.map((val) {
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
                )
              : Container(),
        ],
      ),
    );
  }
}
