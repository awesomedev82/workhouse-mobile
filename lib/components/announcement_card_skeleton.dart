import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workhouse/components/announcement_carousel.dart';

class AnnouncementCardSkeleton extends StatefulWidget {
  final dynamic role;

  const AnnouncementCardSkeleton({Key? key, required this.role})
      : super(key: key);

  @override
  _AnnouncementCardSkeletonState createState() =>
      _AnnouncementCardSkeletonState();
}

class _AnnouncementCardSkeletonState extends State<AnnouncementCardSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: widget.role == "manager"
            ? Color(0xFF349B6F).withOpacity(0.19)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF5F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BlurHash(
                  hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                )),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 18,
                  alignment: Alignment.topRight,
                  child: Text(
                    "Text Text",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: "SF-Pro-Display",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9D9D9D),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                //MARK: Public name
                Container(
                  child: Row(
                    children: [
                      //MARK: Business name
                      Expanded(
                        child: Text(
                          "Business name Business name",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Strictly exclusive for those that have knowledge with Japanese Language Strictly exclusive for those that have knowledge with ",
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      width: double.infinity,
                      height: 180,
                      "assets/images/carousel-1.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
