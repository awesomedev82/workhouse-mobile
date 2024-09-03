import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_card.dart';
import 'package:workhouse/components/app_bottom_navbar.dart';
import 'package:workhouse/components/header_bar.dart';
import 'package:workhouse/components/image_carousel.dart';
import 'package:workhouse/screens/create_announcement/announcement_create_screen.dart';
import 'package:workhouse/screens/create_announcement/share_first_screen.dart';
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
  late SharedPreferences prefs;
  late SupabaseClient supabase;
  String communityID = "";
  List<dynamic> announcements = <dynamic>[];

  @override
  void initState() {
    super.initState();
    getData();
  }



  void getData() async {
    supabase = Supabase.instance.client;
    prefs = await SharedPreferences.getInstance();
    communityID = prefs.getString("communityID")!;
    
    final data = await supabase
        .from("community_logs")
        .select()
        .eq("community_id", communityID);
    //data[0]["images"]
    setState(() {
      announcements = data;
    });
    
  }

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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: APP_WHITE_COLOR,
        ),
        child: Column(
          children: [
            HeaderBar(title: "Workhouse"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        return AnnouncementCard(
                          id: announcements[index]["id"],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            _showAnnouncementInfoModal(context);
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
