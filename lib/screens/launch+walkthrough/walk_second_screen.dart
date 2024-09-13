import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_third_screen.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Walk Second Screen UI Widget Class
 */

class WalkSecondScreen extends StatefulWidget {
  const WalkSecondScreen({Key? key}) : super(key: key);

  @override
  _WalkSecondScreenState createState() => _WalkSecondScreenState();
}

class _WalkSecondScreenState extends State<WalkSecondScreen> {
  @override
  Widget build(BuildContext context) {
    double marginLeft = (MediaQuery.of(context).size.width - 342) / 2;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: APP_WHITE_COLOR),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 42),
            child: Stack(
              children: [
                Positioned.fromRect(
                  rect: Rect.fromLTWH(marginLeft, 144, 300, 300),
                  child: Image.asset(
                    'assets/images/walk_2.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(
                            fontFamily: "Lastik-test",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: APP_BLACK_COLOR,
                          ),
                          child: Text(
                            'Member Directory',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DefaultTextStyle(
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: APP_TEXT_COLOR,
                            ),
                          ),
                          child: Text(
                            'Browse creative profiles and small businesses to find your next collaborator.',
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
