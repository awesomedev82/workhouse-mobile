import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_second_screen.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Walk First Screen UI Widget Class
 */

class WalkFirstScreen extends StatefulWidget {
  const WalkFirstScreen({Key? key}) : super(key: key);

  @override
  _WalkFirstScreenState createState() => _WalkFirstScreenState();
}

class _WalkFirstScreenState extends State<WalkFirstScreen> {
  @override
  Widget build(BuildContext context) {
    double marginLeft = (Get.width - 342) / 2;
    return SingleChildScrollView(
      child: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: APP_WHITE_COLOR),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21, vertical: 42),
          child: Stack(
            children: [
              Positioned.fromRect(
                rect: Rect.fromLTWH(marginLeft, 102, 300, 300),
                child: SvgPicture.asset('assets/images/walk_1.svg'),
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
                          'Community Board',
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
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 62.0,
                            width: 62.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(31),
                            ),
                            child: FittedBox(
                              child: FloatingActionButton(
                                onPressed: () {
                                  Get.to(WalkSecondScreen());
                                },
                                backgroundColor: APP_BLACK_COLOR,
                                foregroundColor: APP_WHITE_COLOR,
                                shape: CircleBorder(),
                                elevation: 0.0,
                                child: SvgPicture.asset(
                                  'assets/images/arrow-right-white.svg',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
