import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_carousel.dart';

class AnnouncementCard extends StatefulWidget {
  const AnnouncementCard({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _AnnouncementCardState createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
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
    print(json.decode(data["images"]));
    for (var media in json.decode(data["images"])) {
      mediasTemp.add({"type": media["type"], "url": media["url"]});
    }

    setState(() {
      publicName =
          role == "member" ? userInfo["public_name"] : userInfo["full_name"];
      businessName = role == "member" ? userInfo["bio"] : "Manager";
      description = data["description"];
      createdAt = timeDifference(data["created_at"]);
      medias = mediasTemp;
    });
  }

  String timeDifference(dynamic targetTime) {
    DateTime now = DateTime.now();
    DateTime utcDate = now.toUtc();
    DateTime targetDate = DateTime.parse(targetTime);

    int differenceInMilliseconds =
        utcDate.millisecondsSinceEpoch - targetDate.millisecondsSinceEpoch;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color:
            widget.id == 1 ? Color(0xFF349B6F).withOpacity(0.19) : Colors.white,
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
            width: 48,
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: avatarURL.isNotEmpty
                  ? Image.network(
                      avatarURL,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.black,
                    ),
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
                    createdAt,
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
                        publicName,
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
                        businessName,
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
                        ? AnnouncementCarousel(data: medias)
                        : Container(),
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
