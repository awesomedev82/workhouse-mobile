import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workhouse/screens/signin+create_account/sign_in_screen.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Walk Fouth Screen UI Widget Class
 */

class WalkFouthScreen extends StatefulWidget {
  const WalkFouthScreen({Key? key}) : super(key: key);

  @override
  _WalkFouthScreenState createState() => _WalkFouthScreenState();
}

class _WalkFouthScreenState extends State<WalkFouthScreen> {
  late SharedPreferences prefs;

  void onNext() async {
    prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString("userID") ?? "";
    String username = prefs.getString("username") ?? "";
    String fullname = prefs.getString("fullname") ?? "";
    String businessName = prefs.getString("businessName") ?? "";
    if (userID.isEmpty) {
      Navigator.pushNamed(context, '/sign-in');
    } else if (fullname.isEmpty) {
      Navigator.pushNamed(context, '/create-account');
    } else if (businessName.isEmpty) {
      Navigator.pushNamed(context, '/add-directory');
    } else {
      Navigator.pushNamed(context, '/community');
    }
  }

  @override
  Widget build(BuildContext context) {
    double marginLeft1 = (MediaQuery.of(context).size.width - 221);
    double marginLeft2 = (MediaQuery.of(context).size.width - 267);
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
                  rect: Rect.fromLTWH(marginLeft1, 0, 179, 179),
                  child: SvgPicture.asset('assets/images/walk_4_1.svg'),
                ),
                Positioned.fromRect(
                  rect: Rect.fromLTWH(0, 178, 205, 205),
                  child: SvgPicture.asset('assets/images/walk_4_2.svg'),
                ),
                Positioned.fromRect(
                  rect: Rect.fromLTWH(marginLeft2, 354, 205, 205),
                  child: SvgPicture.asset('assets/images/walk_4_3.svg'),
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
                            'Skills Marketplace',
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
                            'Offer your unique services and skills to your community.',
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
                                    onNext();
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
