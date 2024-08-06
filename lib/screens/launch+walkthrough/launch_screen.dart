import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_first_screen.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Launch Screen UI Widget Class
 */

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    double secondImageMarginLeft = (Get.width - 256);
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(color: APP_WHITE_COLOR),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 42),
        child: Stack(
          children: [
            Positioned.fromRect(
              rect: Rect.fromLTWH(0, 0, 165, 165),
              child: SvgPicture.asset('assets/images/launch_1.svg'),
            ),
            Positioned.fromRect(
              rect: Rect.fromLTWH(secondImageMarginLeft, 109, 214, 214),
              child: SvgPicture.asset('assets/images/launch_2.svg'),
            ),
            Positioned.fromRect(
              rect: Rect.fromLTWH(0, 297, 242, 242),
              child: SvgPicture.asset('assets/images/launch_3.svg'),
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
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        color: APP_BLACK_COLOR,
                      ),
                      child: Text(
                        'Workhorse',
                      ),
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
                        'The app made for co-working communities.',
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
                                Get.to(WalkFirstScreen());
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
    );
  }
}
