import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_carousel.dart';

class UserAnnouncementCard extends StatefulWidget {
  const UserAnnouncementCard({
    Key? key,
    required this.id,
    required this.index,
    this.onDelete,
    this.isHideDeleteButton = false,
  }) : super(key: key);

  final int id;
  final int index;
  final dynamic isHideDeleteButton;
  final Function? onDelete;

  @override
  _UserAnnouncementCardState createState() => _UserAnnouncementCardState();
}

class _UserAnnouncementCardState extends State<UserAnnouncementCard> {
  late SharedPreferences prefs;
  late SupabaseClient supabase;
  String communityID = "";
  late String senderID = "";
  late String role = "";
  late String publicName = "";
  late String avatarURL = "";
  late String businessName = "";
  late String description = "";
  late String createdAt = "";
  List<dynamic> medias = <dynamic>[];

  @override
  void initState() {
    super.initState();
    getData();
  }

  //MARK: Get data
  void getData() async {
    supabase = Supabase.instance.client;
    dynamic temp =
        await supabase.from("community_logs").select().eq("id", widget.id);
    final data = temp[0];
    temp = await supabase.from("members").select().eq("id", data["sender"]);
    dynamic userInfo;
    if (temp.length == 1) {
      setState(() {
        role = "member";
        avatarURL =
            "https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/${temp[0]["avatar_url"]}";
      });
      userInfo = temp[0];
    }

    temp = await supabase.from("profiles").select().eq("id", data["sender"]);
    if (temp.length == 1) {
      setState(() {
        role = "manager";
        avatarURL =
            "https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/avatars/admin-avatar.png";
      });
      userInfo = temp[0];
    }
    List<dynamic> mediasTemp = <dynamic>[];
    for (var media in json.decode(data["images"])) {
      mediasTemp.add({"type": media["type"], "url": media["url"]});
    }

    setState(() {
      publicName =
          role == "member" ? userInfo["public_name"] : userInfo["full_name"];
      businessName = role == "member" ? userInfo["business_name"] : "Manager";
      description = data["description"];
      createdAt = timeDifference(data["created_at"]);
      medias = mediasTemp;
    });
  }

  String timeDifference(dynamic targetTime) {
    DateTime now = DateTime.now();
    DateTime utcDate = now.toUtc();
    DateTime targetDate = DateTime.parse(targetTime);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
    DateTime newUTC = DateTime.parse(dateFormat.format(utcDate));
    DateTime newTarget = DateTime.parse(dateFormat.format(targetDate));

    int temp1 = newUTC.millisecondsSinceEpoch;
    int temp2 = newTarget.microsecondsSinceEpoch ~/ 1000;

    int differenceInMilliseconds = (temp1 - temp2).abs();
    int differenceInMinutes = (differenceInMilliseconds / (1000 * 60)).floor();
    int differenceInHours =
        (differenceInMilliseconds / (1000 * 60 * 60)).floor();
    int differenceInDays =
        (differenceInMilliseconds / (1000 * 60 * 60 * 24)).floor();

    if (differenceInHours < 1) {
      return '$differenceInMinutes minutes';
    } else if (differenceInHours < 24) {
      return '$differenceInHours hours';
    } else {
      return '$differenceInDays days';
    }
  }

  //MARK: Show delete button
  void _showDeleteBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            height: 142,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0), // TL: Top Left
                topRight: Radius.circular(30.0), // TR: Top Right
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFF2F2F2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 140,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF2F2F2).withOpacity(1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Close",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF17181A),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //MARK: On delete:
                    Navigator.of(context).pop();
                    widget.onDelete!(widget.index, widget.id);
                  },
                  child: Container(
                    height: 70,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF2F2F2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delete Announcement"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: role == "manager"
            ? Color(0xFF349B6F).withOpacity(0.19)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF5F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 24,
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      _showDeleteBottomSheet(context);
                    },
                    child: Icon(
                      Ionicons.ellipsis_horizontal,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                //MARK:
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    description,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: medias.isNotEmpty
                        ? AnnouncementCarousel(height: 240, data: medias)
                        : Container(),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
