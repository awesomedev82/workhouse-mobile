import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Announcement Create Screen UI Widget Class
 */

class AnnouncementCreateScreen extends StatefulWidget {
  const AnnouncementCreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AnnouncementCreateScreenState createState() =>
      _AnnouncementCreateScreenState();
}

class _AnnouncementCreateScreenState extends State<AnnouncementCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                Container(
                  alignment: Alignment.topRight,
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
                SvgPicture.asset("assets/images/announcement.svg"),
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
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF17181A),
                    ),
                  ),
                  child: Text(
                    "Share an announcement on the community board with text, a photo, GIF, or a 1 minute video. To keep the app running we charge a flat fee of \$2 per announcement. ",
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/check.svg"),
                      SizedBox(
                        width: 10,
                      ),
                      DefaultTextStyle(
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 1.31,
                          color: Colors.black,
                        ),
                        child: Text("Benefits"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                // MARK: Benefits
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 50,
                          width: 450,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFD8ECE4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultTextStyle(
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                color: APP_BLACK_COLOR,
                              ),
                            ),
                            child: Text(
                              "Targeted and focused to your local community",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 450,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFD8ECE4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultTextStyle(
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                color: APP_BLACK_COLOR,
                              ),
                            ),
                            child: Text(
                              "Sent to all members of the community",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 450,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFD8ECE4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultTextStyle(
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                color: APP_BLACK_COLOR,
                              ),
                            ),
                            child: Text(
                              "One time fee of \$2 for each announcement.",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                // MARK: Create announcement button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Color(0xFF014E53),
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
                      Navigator.pushNamed(context, '/share-announcement'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
