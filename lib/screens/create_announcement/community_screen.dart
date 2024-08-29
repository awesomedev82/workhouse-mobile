import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workhouse/components/announcement_card.dart';
import 'package:workhouse/components/app_bottom_navbar.dart';
import 'package:workhouse/components/header_bar.dart';
import 'package:workhouse/components/image_carousel.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK Community Screen UI Widget Class
 */

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  void _showCustomModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: <Widget>[
                    //MARK: Title
                    Container(
                      alignment: Alignment.centerLeft,
                      child: DefaultTextStyle(
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.42,
                          fontFamily: "Lastik-test",
                          color: Color(0xFF101010),
                        ),
                        child: Text(
                          "Share an announcement",
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    // MARK: Description
                    DefaultTextStyle(
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF17181A),
                        ),
                      ),
                      child: Text(
                        "Share an announcement on the community board with text, a photo, GIF, or a 1 minute video. To keep the app running we charge a flat fee of \$2 per announcement. ",
                      ),
                    ),
                    SizedBox(height: 24),
                    // MARK: Benefits
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFD8ECE4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: DefaultTextStyle(
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Lastik-test",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.31,
                                color: Colors.black,
                              ),
                              child: Text("Benefits"),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      child: Image.asset(
                                        "assets/images/check.png",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            height: 1.6,
                                            color: APP_BLACK_COLOR,
                                          ),
                                        ),
                                        child: Text(
                                          "Targeted and focused on your local community.",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      child: Image.asset(
                                        "assets/images/check.png",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            height: 1.6,
                                            color: APP_BLACK_COLOR,
                                          ),
                                        ),
                                        child: Text(
                                          "Announcement sent to all members of the community.",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      child: Image.asset(
                                        "assets/images/check.png",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            height: 1.6,
                                            color: APP_BLACK_COLOR,
                                          ),
                                        ),
                                        child: Text(
                                          "One time low cost of \$2 for each announcement.",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    // MARK: Create announcement button
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            APP_BLACK_COLOR,
                          ),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              // side: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () => {
                          Navigator.of(context).pop(),
                        },
                        child: Text(
                          'Create announcement',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 1.21,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // MARK: X button
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color(0xFFEFEFF0),
                          ),
                          child: Image.asset("assets/images/x.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: APP_WHITE_COLOR,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderBar(title: "Workhouse"),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Text(
                  "Sponsored",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    color: APP_BLACK_COLOR,
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ImageCarousel(),
              AnnouncementCard(
                category: "main",
              ),
              AnnouncementCard(
                category: "other",
              ),
              AnnouncementCard(
                category: "other",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavbar(),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color(0xFFAAD130),
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showCustomModal(context);
          },
          backgroundColor: Color(0xFFAAD130),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Icon(
            Ionicons.add_outline,
            size: 24,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
