import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workhouse/components/announcement_carousel.dart';

class AccountAnnouncementCardSkeleton extends StatefulWidget {
  final dynamic role;

  const AccountAnnouncementCardSkeleton({Key? key, required this.role})
      : super(key: key);

  @override
  _AccountAnnouncementCardSkeletonState createState() =>
      _AccountAnnouncementCardSkeletonState();
}

class _AccountAnnouncementCardSkeletonState extends State<AccountAnnouncementCardSkeleton> {
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Strictly exclusive for those that have knowledge with Japanese Language Strictly exclusive for those that have knowledge with  exclusive for those that have knowledge with",
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



