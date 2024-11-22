import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_carousel.dart';
import 'package:workhouse/components/app_toast.dart';
import 'package:workhouse/components/skeleton_component.dart';
import 'package:workhouse/utils/announcement_provider.dart';

class SelectedAnnouncementScreen extends StatefulWidget {
  final int? id;
  final int? idx;
  const SelectedAnnouncementScreen({
    Key? key,
    required this.data,
    this.id,
    this.idx,
  }) : super(key: key);

  final dynamic data;

  @override
  _SelectedAnnouncementScreenState createState() =>
      _SelectedAnnouncementScreenState();
}

class _SelectedAnnouncementScreenState
    extends State<SelectedAnnouncementScreen> {
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
  String _searchValue = "";
  List<dynamic> _searchResult = <dynamic>[];
  bool _isLoading = true;
  List<dynamic> medias = <dynamic>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    getData();
  }

  void getData() async {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    supabase = Supabase.instance.client;
    prefs = await SharedPreferences.getInstance();
    communityID = prefs.getString("communityID")!;

    dynamic temp = await supabase
        .from("community_logs")
        .select()
        .eq("id", widget.id ?? "");
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
                        padding: EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 140,
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
                      log("IssssssssssssssssssssssD: ${widget.data["id"]}");
                      log("IsssssD: ${widget.id}");
                      // await supabase.from("community_logs").update(
                      //     {'hide': true}).eq("id", {widget.id.toString()});
                      await supabase
                          .from("community_logs")
                          .update({'hide': true}).eq("id", widget.id!);

                      log("IssswwwwwssD: ${widget.data["id"]}");
                      final announcementProvider =
                          Provider.of<AnnouncementProvider>(
                        context,
                        listen: false,
                      );
                      log("provider1: ${announcementProvider.announcements.length}");
                      List<dynamic> announcements =
                          announcementProvider.announcements;
                      announcements.removeAt(widget.idx!);
                      log("provider2: ${announcementProvider.announcements.length}");

                      Provider.of<AnnouncementProvider>(context, listen: false)
                          .setMyAnnouncements(announcements);
                      log("provider3: ${announcementProvider.announcements.length}");

                      showAppToast(context, "Hidden successfully!");
                    } catch (e) {
                      log("provider1: ${e.toString()}");
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
                        Text("Hide Announcement",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF17181A),
                            )),
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

  void selectMember(id) async {
    print(id);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedMemberID", id);
    Navigator.of(context).pushNamed('/selected-member');
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    dynamic announcements = announcementProvider.announcements;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: _isLoading == false
            ? Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 48,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Ensure the elements are spaced evenly
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(
                                    0xFFE9EAEC)), // Background color for the back button
                            child: SvgPicture.asset(
                                "assets/images/arrow-left.svg"), // SVG for the back arrow
                          ),
                        ),
                        SizedBox(
                          width: 190,
                        ),
                        // Menu button (ellipsis)
                        // if (announcements[widget.idx]["public_name"] != "" &&
                        //     announcements[widget.idx]["business_name"] != "" &&
                        //     announcements[widget.idx]["role"] != "manager")
                        GestureDetector(
                          onTap: () {
                            print(widget.id);
                            log("ID: ${widget.idx}");
                            log("ID: ${widget.id}");
                            log("ID: ${widget.data["id"]}");
                            log("ID: ${widget.data}");
                            _showDeleteBottomSheet(context);
                          },
                          child: Container(
                            height: 24,
                            width: 24, // Specify width to avoid layout issues
                            alignment: Alignment.center,
                            child: Icon(
                              Ionicons.ellipsis_horizontal, // Three dots icon
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: 500,
                      child: getMediaData(widget.data["images"]).isNotEmpty
                          ? AnnouncementCarousel(
                              height: 230,
                              data: getMediaData(
                                widget.data["images"],
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  child: GestureDetector(
                                    onTap: () {
                                      //   selectMember(["id"]);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.data["avatar_url"],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const AspectRatio(
                                          aspectRatio: 1.6,
                                          child: BlurHash(
                                            hash:
                                                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.data["role"] == "member"
                                  ? Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                widget.data["public_name"],
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  height: 1.3,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Lastik-test",
                                                ),
                                              ),
                                              // SizedBox(
                                              //   width: 4,
                                              // ),
                                              // Container(
                                              //   width: 10,
                                              //   height: 2,
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(11),
                                              //     color: Colors.black,
                                              //   ),
                                              // ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  height: 1.3,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Lastik-test",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      child: Text(
                                        widget.data["public_name"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          height: 1.3,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Lastik-test",
                                        ),
                                      ),
                                    ),
                              // Text(
                              //   timeDifference(
                              //     widget.data["created_at"],
                              //   ),
                              //   textAlign: TextAlign.right,
                              //   style: TextStyle(
                              //     fontFamily: "SF-Pro-Display",
                              //     fontWeight: FontWeight.w400,
                              //     color: Color(0xFF9D9D9D),
                              //     fontSize: 13,
                              //     height: 1.4,
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.data["description"],
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  height: 1.6,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF0F1324).withOpacity(0.5)),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 48,
                    ),
                    // Back button
                    Skeletonizer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Ensure the elements are spaced evenly
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(
                                      0xFFE9EAEC)), // Background color for the back button
                              // SVG for the back arrow
                            ),
                          ),
                          SizedBox(
                            width: 190,
                          ),
                          // Menu button (ellipsis)
                          GestureDetector(
                            onTap: () {
                              _showDeleteBottomSheet(
                                  context); // Trigger the bottom sheet on tap
                            },
                            child: Container(
                                height: 24,
                                width:
                                    24, // Specify width to avoid layout issues
                                alignment: Alignment.center,
                                child: Text("Icons-----------")),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    // Image Carousel or Skeleton Placeholder
                    Skeletonizer(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: getMediaData(widget.data["images"]).isNotEmpty
                              ? AnnouncementCarousel(
                                  height: 230,
                                  data: getMediaData(widget.data["images"]),
                                )
                              : Container(), // Empty container if no images
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profile Picture Skeleton
                                Skeletonizer(
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.data["avatar_url"],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const AspectRatio(
                                          aspectRatio: 1.6,
                                          child: BlurHash(
                                              hash:
                                                  'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Skeletonizer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.data["role"] == "member"
                                    ? Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "public_name",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    height: 1.3,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Lastik-test",
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                // Container(
                                                //   width: 10,
                                                //   height: 2,
                                                //   decoration: BoxDecoration(
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             11),
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                // SizedBox(
                                                //   width: 4,
                                                // ),
                                                // Text(
                                                //   "business_name",
                                                //   style: TextStyle(
                                                //     fontSize: 24,
                                                //     height: 1.3,
                                                //     color: Colors.black,
                                                //     fontWeight: FontWeight.w600,
                                                //     fontFamily: "Lastik-test",
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        child: Text(
                                          "public name",
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Lastik-test",
                                          ),
                                        ),
                                      ),
                                // Text(
                                //   timeDifference(
                                //     widget.data["created_at"],
                                //   ),
                                //   textAlign: TextAlign.right,
                                //   style: TextStyle(
                                //     fontFamily: "SF-Pro-Display",
                                //     fontWeight: FontWeight.w400,
                                //     color: Color(0xFF9D9D9D),
                                //     fontSize: 13,
                                //     height: 1.4,
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 18,
                          ),

                          // Description Text Skeleton
                          Skeletonizer(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Hello, this is the test announcement. In the context of graphics and image processing, a skeletonizer",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  height: 1.6,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

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
        position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}
