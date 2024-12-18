import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workhouse/utils/constant.dart';

class HeaderBar extends StatefulWidget {
  const HeaderBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  _HeaderBarState createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEAE6E6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.title == "Workhouse"
              ? SvgPicture.asset(
                  "assets/images/logos.svg",
                  height: 35,
                )
              : Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: "Lastik-test",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: APP_BLACK_COLOR,
                  ),
                ),
          // SizedBox(
          //   width: 8,
          // ),
          // widget.title == "Workhouse"
          //     ? Container(
          //         padding: EdgeInsets.symmetric(
          //           vertical: 8,
          //           horizontal: 12,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Color(0xFF014E53),
          //           borderRadius: BorderRadius.circular(9),
          //         ),
          //         child: Text(
          //           "BETA",
          //           style: TextStyle(
          //             // fontFamily: "Lastik-test",
          //             fontSize: 10,
          //             fontWeight: FontWeight.w400,
          //             color: Color(0xFFF5F5F5),
          //           ),
          //         ),
          //       )
          //     : Container(
          //         padding: EdgeInsets.symmetric(
          //           vertical: 8,
          //           horizontal: 12,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Color(0xFFFFFFFF),
          //           borderRadius: BorderRadius.circular(9),
          //         ),
          //         child: Text(
          //           "BETA",
          //           style: TextStyle(
          //             // fontFamily: "Lastik-test",
          //             fontSize: 10,
          //             fontWeight: FontWeight.w400,
          //             color: Color(0xFFFFFFFF),
          //           ),
          //         ),
          //       ),
        ],
      ),
    );
  }
}
