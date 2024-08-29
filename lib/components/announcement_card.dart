import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementCard extends StatefulWidget {
  const AnnouncementCard({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  _AnnouncementCardState createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: widget.category == "main"
            ? Color(0xFF349B6F).withOpacity(0.19)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFFAF6F6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/walk_2.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 18,
                  alignment: Alignment.topRight,
                  child: Text(
                    "2 Hours",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: "SF-Pro-Display",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9D9D9D),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        "One Eyed Studios",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Lastik-test",
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        width: 2,
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Rockella Space",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF17181A),
                            fontWeight: FontWeight.w300,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry printing and typesetting industry.",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/carousel-2.png",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
