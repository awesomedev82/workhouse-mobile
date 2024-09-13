import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/screens/create_announcement/announcement_create_screen.dart';

class CommunityEmptyScreen extends StatefulWidget {
  const CommunityEmptyScreen({Key? key}) : super(key: key);

  @override
  _CommunityEmptyScreenState createState() => _CommunityEmptyScreenState();
}

class _CommunityEmptyScreenState extends State<CommunityEmptyScreen> {
  void _showAnnouncementInfoModal(BuildContext context) {
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
        return AnnouncementCreateScreen();
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 108,
          ),
          Text(
            "Welcome to Workhouse!",
            style: TextStyle(
              fontFamily: 'Lastik-test',
              fontSize: 24,
              height: 1.62,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101010),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            width: 214,
            height: 214,
            child: SvgPicture.asset("assets/images/community_empty.svg"),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            textAlign: TextAlign.center,
            "This is where you will see announcements. Connect, collaborate, and stay informed with your community.",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w400,
                color: Color(0xFF17181A),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          AppButton(
            text: "Create a paid announcement",
            onTapped: () {
              _showAnnouncementInfoModal(context);
            },
          )
        ],
      ),
    );
  }
}
