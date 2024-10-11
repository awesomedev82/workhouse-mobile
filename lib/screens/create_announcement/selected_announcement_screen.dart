import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_carousel.dart';

class SelectedAnnouncementScreen extends StatefulWidget {
  const SelectedAnnouncementScreen({Key? key, required this.data})
      : super(key: key);

  final dynamic data;

  @override
  _SelectedAnnouncementScreenState createState() =>
      _SelectedAnnouncementScreenState();
}

class _SelectedAnnouncementScreenState
    extends State<SelectedAnnouncementScreen> {
  late SharedPreferences prefs;
  late SupabaseClient supabase;

  bool isLoading = true;
  List<dynamic> medias = <dynamic>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getData();
  }

  void getData() async {}

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 48,
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset("assets/images/arrow-left.svg"),
                  ),
                ),
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
                        children: [
                          Container(
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
                                    hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.data["role"] == "member"
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    widget.data["public_name"],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      height: 1.3,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    widget
                                                        .data["business_name"],
                                                    style: GoogleFonts.inter(
                                                      textStyle: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF17181A),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Text(
                                            widget.data["public_name"],
                                            style: TextStyle(
                                              fontSize: 16,
                                              height: 1.3,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Lastik-test",
                                            ),
                                          ),
                                    Text(
                                      timeDifference(widget.data["created_at"]),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: "SF-Pro-Display",
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF9D9D9D),
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                                // if (widget.data["role"] == "member")
                                //   Text(
                                //     "Member Spotlight: ${widget.data["public_name"]}",
                                //     overflow: TextOverflow.ellipsis,
                                //     maxLines: 1,
                                //     style: GoogleFonts.inter(
                                //       textStyle: TextStyle(
                                //         fontSize: 14,
                                //         color: Color(0xFF17181A),
                                //         fontWeight: FontWeight.w300,
                                //         height: 1.6,
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: getMediaData(widget.data["images"]).isNotEmpty
                            ? AnnouncementCarousel(
                                height: 230,
                                data: getMediaData(
                                  widget.data["images"],
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.data["description"],
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   child: Container(
                    //     width: 20,
                    //     height: 20,
                    //     child: SvgPicture.asset('assets/images/Iconly.svg'),
                    //   ),
                    // ),
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
