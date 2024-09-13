import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_carousel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:workhouse/utils/announcement_provider.dart';

class AnnouncementCard extends StatefulWidget {
  const AnnouncementCard({Key? key, required this.id, required this.idx})
      : super(key: key);

  final int id;

  final int idx;

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
  late String communityName = "";
  List<dynamic> medias = <dynamic>[];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    supabase = Supabase.instance.client;
    prefs = await SharedPreferences.getInstance();
    communityID = prefs.getString("communityID")!;
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
      dynamic cdata =
          await supabase.from("communities").select().eq("id", communityID);
      print("communityData:\n${cdata[0]["logo_url"]}");
      setState(() {
        role = "manager";
        avatarURL = cdata[0]["logo_url"];
        communityName = cdata[0]["name"];
      });
      userInfo = temp[0];
    }
    List<dynamic> mediasTemp = <dynamic>[];
    for (var media in json.decode(data["images"])) {
      mediasTemp.add({"type": media["type"], "url": media["url"]});
    }

    setState(() {
      try {
        publicName =
            role == "member" ? userInfo["public_name"] : userInfo["full_name"];
        businessName = role == "member" ? userInfo["business_name"] : "Manager";
        description = data["description"];
        createdAt = timeDifference(data["created_at"]);
        medias = mediasTemp;
        print(
            "---------------------------------><---------------------------------");
      } catch (e) {
        print(e);
      }
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

  List<dynamic> getMediaData(data) {
    List<dynamic> mediasData = <dynamic>[];
    for (var media in json.decode(data)) {
      mediasData.add({"type": media["type"], "url": media["url"]});
    }
    return mediasData;
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    dynamic announcements = announcementProvider.announcements;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
          Container(
            width: 48,
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: announcements[widget.idx]["avatar_url"] != null
                  ? CachedNetworkImage(
                      imageUrl: announcements[widget.idx]["avatar_url"],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const AspectRatio(
                        aspectRatio: 1.6,
                        child: BlurHash(
                          hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.white,
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
                //MARK: Public name
                Container(
                  child: Row(
                    children: [
                      Text(
                        announcements[widget.idx]["public_name"],
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
                      if (announcements[widget.idx]["public_name"] != "" &&
                          announcements[widget.idx]["business_name"] != "" &&
                          announcements[widget.idx]["role"] != "manager")
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
                      //MARK: Business name
                      if (announcements[widget.idx]["role"] == "member")
                        Expanded(
                          child: Text(
                            announcements[widget.idx]["business_name"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF17181A),
                                fontWeight: FontWeight.w300,
                                height: 1.6,
                              ),
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
                    announcements[widget.idx]["description"],
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
                    child: announcements[widget.idx]["images"] != null
                        ? AnnouncementCarousel(
                            data: getMediaData(
                              announcements[widget.idx]["images"],
                            ),
                          )
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
