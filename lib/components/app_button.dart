import 'package:flutter/material.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:google_fonts/google_fonts.dart';

/**
 * MARK: App Button Widget Class
 */
class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.text,
    required this.onTapped,
    this.color = 0xFF014E53,
  }) : super(key: key);
  final String text;
  final Function() onTapped;
  final dynamic color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      decoration: BoxDecoration(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(color),
          foregroundColor: Color(color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          side: BorderSide(
            color: Color(color),
            width: 1.0,
            style: BorderStyle.solid,
          ),
          minimumSize: Size(MediaQuery.of(context).size.width - 40, 43),
          elevation: 0.8,
        ),
        onPressed: onTapped,
        onLongPress: () => {},
        child: Text(
          text,
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: Color(0xFFFEFEFE),
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              height: 1.21,
            ),
          ),
        ),
      ),
    );
  }
}
