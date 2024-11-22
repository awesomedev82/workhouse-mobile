import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_carousel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:workhouse/components/app_bottom_navbar.dart';
import 'package:workhouse/components/app_toast.dart';
import 'package:workhouse/utils/announcement_provider.dart';

class AnnouncementCardDescription extends StatefulWidget {
  const AnnouncementCardDescription(
      {Key? key, required this.id, required this.idx})
      : super(key: key);

  final int id;

  final int idx;

  @override
  _AnnouncementCardDescriptionState createState() =>
      _AnnouncementCardDescriptionState();
}

class _AnnouncementCardDescriptionState
    extends State<AnnouncementCardDescription> {
  late SharedPreferences prefs;
  late SupabaseClient supabase;
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString); // Parse the HTML
    final String parsedString = document.body?.text ?? ""; // Extract plain text
    return parsedString.trim(); // Trim extra spaces or newlines
  }

  String communityID = "";
  late String senderID = "";
  late String role = "";
  late String publicName = "";
  late String avatarURL = "";
  late String businessName = "";
  late String description = "";
  late String title = "";
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
    print("TEMP DAATAAAA");
    log(temp.toString());
    print("IDDDDDDDDDDDDD$widget.id");
    print(temp[0]["title"]);
    print(temp[0]["id"]);
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
      // print("communityData:\n${cdata[0]["logo_url"]}");
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
        // print(data["description"]);
        // print(data["title"]);
        publicName =
            role == "member" ? userInfo["public_name"] : userInfo["full_name"];
        businessName = role == "member" ? userInfo["business_name"] : "Manager";
        description = data["description"];
        title = data["title"];
        createdAt = timeDifference(data["created_at"]);
        medias = mediasTemp;
        // print(
        //     "---------------------------------><---------------------------------");
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

  //MARK: Show delete button
  void _showDeleteBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            height: 102,
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
                  height: 30,
                  // padding: EdgeInsets.fromLTRB(20, 16, 20, 0),

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
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF2F2F2).withOpacity(1),
                                    borderRadius: BorderRadius.circular(5),
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
                GestureDetector(
                  onTap: () async {
                    //MARK: On delete:

                    _showProgressModal(context);
                    try {
                      await supabase
                          .from("community_logs")
                          .update({'hide': true}).eq("id", widget.id);
                      final announcementProvider =
                          Provider.of<AnnouncementProvider>(context,
                              listen: false);
                      List<dynamic> announcements =
                          announcementProvider.announcements;
                      announcements.removeAt(widget.idx);

                      Provider.of<AnnouncementProvider>(context, listen: false)
                          .setMyAnnouncements(announcements);
                      showAppToast(context, "Hidden successfully!");
                    } catch (e) {
                      showAppToast(context, "Error occured!");
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          width: 30,
                          height: 30,
                          'assets/images/hide_announcement_icon.svg',
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text("Hide Announcement"),
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

  // MARK: Loading Progress Animation
  void _showProgressModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LoadingAnimationWidget.hexagonDots(
                      color: Colors.blue, size: 32),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    dynamic announcements = announcementProvider.announcements;
    final String plainTextDescription =
        _parseHtmlString(announcements[widget.idx]["description"]);
    // final selectedAnnouncement = announcements.firstWhere(
    //   (announcement) => announcement["id"] == widget.id,
    //   orElse: () => null, // Return null if not found
    // );

    // if (selectedAnnouncement == null) {
    //   return Scaffold(
    //     body: Center(child: Text("Announcement not found")),
    //   );
    // }

    return Container(
      padding: announcements[widget.idx]["role"] == "manager"
          ? EdgeInsets.symmetric(horizontal: 25, vertical: 15)
          : EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: announcements[widget.idx]["role"] == "manager"
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
                    timeDifference(announcements[widget.idx]["created_at"]),
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
                        announcements[widget.idx]["public_name"].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Lastik-test",
                        ),
                      ),
                      // Text(
                      //   announcements[widget.idx]["public_name"] ?? "",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     height: 1.3,
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.w600,
                      //     fontFamily: "Lastik-test",
                      //   ),
                      // ),
                      SizedBox(
                        width: 4,
                      ),
                      if (announcements[widget.idx]["public_name"] != "" &&
                          announcements[widget.idx]["business_name"] != "" &&
                          announcements[widget.idx]["role"] != "manager")
                        // Container(
                        //   width: 2,
                        //   height: 2,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(1),
                        //     color: Colors.black,
                        //   ),
                        // ),
                        SizedBox(
                          width: 4,
                        ),
                      //MARK: Business name
                      if (announcements[widget.idx]["role"] == "member")
                        Expanded(
                          child: Text(
                            "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF17181A),
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      if (announcements[widget.idx]["public_name"] != "" &&
                          announcements[widget.idx]["business_name"] != "" &&
                          announcements[widget.idx]["role"] != "manager")
                        // SizedBox(
                        //   width: 100,
                        // ),
                        GestureDetector(
                          onTap: () {
                            print(widget.id);
                            _showDeleteBottomSheet(context);
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            child: Icon(Ionicons.ellipsis_horizontal),
                          ),
                        ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    announcements[widget.idx]["title"].toString(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
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
