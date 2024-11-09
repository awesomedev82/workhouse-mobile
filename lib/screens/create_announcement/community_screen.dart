import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/announcement_card.dart';
import 'package:workhouse/components/announcement_card_skeleton.dart';
import 'package:workhouse/components/app_bottom_navbar.dart';
import 'package:workhouse/components/app_toast.dart';
import 'package:workhouse/components/header_bar.dart';
import 'package:workhouse/components/image_carousel.dart';
import 'package:workhouse/screens/create_announcement/announcement_create_screen.dart';
import 'package:workhouse/screens/create_announcement/community_empty_screen.dart';
import 'package:workhouse/screens/create_announcement/share_first_screen.dart';
import 'package:workhouse/utils/announcement_provider.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:flutter_pull_up_down_refresh/flutter_pull_up_down_refresh.dart';

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
  late SupabaseClient supabaseIns;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    supabaseIns = Supabase.instance.client;
    supabaseIns
        .from('community_logs')
        .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> events) {
      for (var event in events) {
        // Handle the event
        // You might want to call a function to send a notification
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showProgressModal(context);
    });
    getData();
    initFirebaseMessaging();
  }

  // MARK: Init data
  Future<void> getData() async {
    // setState(() {
    //   _isLoading = true;
    // });
    supabase = Supabase.instance.client;
    prefs = await SharedPreferences.getInstance();
    communityID = prefs.getString("communityID")!;

    final data = await supabase
        .from("community_logs_with_sender")
        .select()
        .not('hide', 'eq', true)
        .eq("community_id", communityID)
        .order('role', ascending: true)
        .order("created_at", ascending: false);

    print(data.length);

    // Update announcements in provider
    Provider.of<AnnouncementProvider>(context, listen: false)
        .setAnnouncements(data);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });

    setState(() {
      _isLoading = false;
    });
    return;
  }

  // MARK: Messaging
  void initFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      final userID = supabase.auth.currentUser!.id;
      await supabase.from("member_fcm_tokens").upsert({
        'id': userID,
        'token': fcmToken,
      });
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      final userID = supabase.auth.currentUser!.id;
      await supabase.from("member_fcm_tokens").upsert({
        'id': userID,
        'token': fcmToken,
      });
    });
    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;
      if (notification != null) {
        print("---------------new annnouncement---------------");
        showAppToast(context, "New announcement created");
      }
    });
  }

  // MARK: Select Announcement
  Future<void> onSelectAnnouncement(data) async {
    print(data);
    Navigator.of(context).pushNamed(
      '/selected-announcement',
      arguments: {
        'data': data,
      },
    );
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
    return Scaffold(
      body: Consumer<AnnouncementProvider>(
        builder: (context, announcementProvider, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: APP_WHITE_COLOR,
            ),
            child: Column(
              children: [
                HeaderBar(title: "Workhouse"),
                announcementProvider.announcements.isEmpty
                    ? CommunityEmptyScreen()
                    : Expanded(
                        child: FlutterPullUpDownRefresh(
                          scrollController: ScrollController(),
                          showRefreshIndicator: true,
                          refreshIndicatorColor: Color(0xFFDC6803),
                          isLoading: false,
                          loadingColor: Colors.red,
                          loadingBgColor: Colors.grey.withAlpha(100),
                          isBootomLoading: false,
                          bottomLoadingColor: Colors.green,
                          scaleBottomLoading: 0.6,
                          onRefresh: () async {
                            _showProgressModal(context);
                            await getData();
                            // End refresh
                          },
                          onAtBottom: (status) {},
                          onAtTop: (status) {
                            if (kDebugMode) {
                              print("Scroll at Top");
                            }
                          },
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
                              _isLoading
                                  ? Skeletonizer(
                                      child: ImageCarousel(),
                                    )
                                  : ImageCarousel(),
                         _isLoading ?     Skeletonizer(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Color(0xFFEDFDF4),
                                    // border: Border.all(
                                    //   color: Color(0xFF014E53).withOpacity(0.1),
                                    //   width: 1,
                                    // ),
                                  ),
                                  width: 400,
                                  height: 700,
                                  child: Container(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection:
                                          Axis.horizontal, // Horizontal scroll
                                      itemCount: announcementProvider
                                          .announcements.length,
                                      itemBuilder: (context, index) {
                                        final announcement = announcementProvider
                                            .announcements[index];
                                
                                        // Only show the AnnouncementCard if the role is 'manager'
                                        if (announcement["role"] != "manager") {
                                          return SizedBox
                                              .shrink(); // Don't show the card for non-'manager' roles
                                        }
                                
                                        return
                                            // _isLoading
                                            //     ? Skeletonizer(
                                            //         child: AnnouncementCardSkeleton(
                                            //           role: announcement["role"],
                                            //         ),
                                            //       )
                                            //:
                                            GestureDetector(
                                          onTap: () {
                                            onSelectAnnouncement(announcement);
                                          },
                                          child: Container(
                                            height:
                                                250, // Adjust height if necessary
                                            width: 330, // Width of each item
                                            margin: EdgeInsets.only(
                                                left:
                                                    3), // Optional: Add spacing between items
                                            child: AnnouncementCard(
                                              id: announcement["id"],
                                              idx: index,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ):   Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Color(0xFFEDFDF4),
                                    // border: Border.all(
                                    //   color: Color(0xFF014E53).withOpacity(0.1),
                                    //   width: 1,
                                    // ),
                                  ),
                                  width: 400,
                                  height: 700,
                                  child: Container(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection:
                                          Axis.horizontal, // Horizontal scroll
                                      itemCount: announcementProvider
                                          .announcements.length,
                                      itemBuilder: (context, index) {
                                        final announcement = announcementProvider
                                            .announcements[index];
                                
                                        // Only show the AnnouncementCard if the role is 'manager'
                                        if (announcement["role"] != "manager") {
                                          return SizedBox
                                              .shrink(); // Don't show the card for non-'manager' roles
                                        }
                                
                                        return
                                            // _isLoading
                                            //     ? Skeletonizer(
                                            //         child: AnnouncementCardSkeleton(
                                            //           role: announcement["role"],
                                            //         ),
                                            //       )
                                            //:
                                            GestureDetector(
                                          onTap: () {
                                            onSelectAnnouncement(announcement);
                                          },
                                          child: Container(
                                            height:
                                                250, // Adjust height if necessary
                                            width: 330, // Width of each item
                                            margin: EdgeInsets.only(
                                                left:
                                                    3), // Optional: Add spacing between items
                                            child: AnnouncementCard(
                                              id: announcement["id"],
                                              idx: index,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                             

                           _isLoading ?   Skeletonizer(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 3),
                                  child: ListView.builder(
                                    // itemExtent: 350,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        announcementProvider.announcements.length,
                                    itemBuilder: (context, index) {
                                      final announcement = announcementProvider
                                          .announcements[index];
                                
                                      // Check your condition, for example, when role is 'manager'
                                      if (announcement["role"] == "manager") {
                                        // If the condition matches, return an empty widget or skip the card
                                        return SizedBox
                                            .shrink(); // This will render nothing
                                      }
                                
                                      return
                                          //_isLoading
                                          // ? Skeletonizer(
                                          //     child: AnnouncementCardSkeleton(
                                          //       role: announcement["role"] !=
                                          //           "manager",
                                          //     ),
                                          //   )
                                          // :
                                          GestureDetector(
                                        onTap: () {
                                          onSelectAnnouncement(announcement);
                                        },
                                        child: AnnouncementCard(
                                          id: announcement["id"],
                                          idx: index,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ):Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 3),
                                  child: ListView.builder(
                                    // itemExtent: 350,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        announcementProvider.announcements.length,
                                    itemBuilder: (context, index) {
                                      final announcement = announcementProvider
                                          .announcements[index];
                                
                                      // Check your condition, for example, when role is 'manager'
                                      if (announcement["role"] == "manager") {
                                        // If the condition matches, return an empty widget or skip the card
                                        return SizedBox
                                            .shrink(); // This will render nothing
                                      }
                                
                                      return
                                          //_isLoading
                                          // ? Skeletonizer(
                                          //     child: AnnouncementCardSkeleton(
                                          //       role: announcement["role"] !=
                                          //           "manager",
                                          //     ),
                                          //   )
                                          // :
                                          GestureDetector(
                                        onTap: () {
                                          onSelectAnnouncement(announcement);
                                        },
                                        child: AnnouncementCard(
                                          id: announcement["id"],
                                          idx: index,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              // ListView.builder(
                              //   padding: EdgeInsets.zero,
                              //   shrinkWrap: true,
                              //   physics: NeverScrollableScrollPhysics(),
                              //   // Horizontal scroll
                              //   itemCount:
                              //       announcementProvider.announcements.length,
                              //   itemBuilder: (context, index) {
                              //     return _isLoading
                              //         ? Skeletonizer(
                              //             child: AnnouncementCardSkeleton(
                              //               role: announcementProvider
                              //                   .announcements[index]["role"],
                              //             ),
                              //           )
                              //         : GestureDetector(
                              //             onTap: () {
                              //               onSelectAnnouncement(
                              //                 announcementProvider
                              //                     .announcements[index],
                              //               );
                              //             },
                              //             child: Container(
                              //               height: 900,
                              //               width: 300, // Width of each item
                              //               child: AnnouncementCard(
                              //                 id: announcementProvider
                              //                     .announcements[index]["id"],
                              //                 idx: index,
                              //               ),
                              //             ),
                              //           );
                              //   },
                              // )

                              // SizedBox(
                              //   child: ListView.builder(
                              //     padding: EdgeInsets.zero,
                              //     scrollDirection: Axis.horizontal,
                              //     shrinkWrap: true,
                              //     // physics: NeverScrollableScrollPhysics(),
                              //     itemCount:
                              //         announcementProvider.announcements.length,
                              //     itemBuilder: (context, index) {
                              //       return _isLoading
                              //           ? Skeletonizer(
                              //               child: AnnouncementCardSkeleton(
                              //                 role: announcementProvider
                              //                     .announcements[index]["role"],
                              //               ),
                              //             )
                              //           : GestureDetector(
                              //               onTap: () {
                              //                 onSelectAnnouncement(
                              //                   announcementProvider
                              //                       .announcements[index],
                              //                 );
                              //               },
                              //               child: AnnouncementCard(
                              //                 id: announcementProvider
                              //                     .announcements[index]["id"],
                              //                 idx: index,
                              //               ),
                              //             );
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavbar(
        index: 0,
      ),
      floatingActionButton: Consumer<AnnouncementProvider>(
        builder: (context, announcementProvider, child) {
          return announcementProvider.announcements.isEmpty
              ? Container()
              : Container(
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
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
