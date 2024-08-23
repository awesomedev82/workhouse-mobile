import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_fouth_screen.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Walk Third Screen UI Widget Class
 */

class WalkThirdScreen extends StatefulWidget {
  const WalkThirdScreen({ Key? key }) : super(key: key);

  @override
  _WalkThirdScreenState createState() => _WalkThirdScreenState();
}

class _WalkThirdScreenState extends State<WalkThirdScreen> {
  @override
  Widget build(BuildContext context) {
    double marginLeft = (MediaQuery.of(context).size.width - 362) / 2;
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
                  rect: Rect.fromLTWH(marginLeft, 144, 310, 310),
                  child: SvgPicture.asset('assets/images/launch_2.svg'),
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
                            color: APP_BLACK_COLOR
                          ),
                          child: Text(
                            'Paid Announcements',
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
                            'Share an announcement on the community board for a flat fee of \$2 to reach your entire community. ',
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
                                    Navigator.pushNamed(context, '/walk-fouth');
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
      ),
    );
  }
}