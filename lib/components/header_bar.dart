import 'package:flutter/material.dart';
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
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEAE6E6),
            width: 1,
          ),
        ),
      ),
      child: Text(
        widget.title,
        style: TextStyle(
          fontFamily: "Lastik-test",
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: APP_BLACK_COLOR,
        ),
      ),
    );
  }
}
