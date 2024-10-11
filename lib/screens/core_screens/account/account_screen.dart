import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workhouse/components/app_bottom_navbar.dart';
import 'package:workhouse/components/app_toast.dart';
import 'package:workhouse/components/user_announcement_card.dart';
import 'package:workhouse/utils/announcement_provider.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:workhouse/utils/profile_provider.dart';

/**
 * MARK: Account Screen UI Widget Class
 */

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late SharedPreferences prefs;
  final ImagePicker _picker = ImagePicker();
  late SupabaseClient supabase;
  String _avatar = "";
  String _pname = "";
  String _bname = "";
  String _bio = "";
  String _website = "";
  String _cname = "";
  bool _isLoding = true;
  List<dynamic> announcements = <dynamic>[];

  String prefixURL =
      "https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/";

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoding = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showProgressModal(context);
    });
    getData();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    supabase = Supabase.instance.client;
    setState(() {
      _avatar = prefixURL + prefs.getString("avatar")!;
    });
    String userID = prefs.getString("userID")!;
    final userdata =
        await supabase.from("member_community_view").select().eq("id", userID);
    final adata = await supabase
        .from("community_logs")
        .select()
        .eq("sender", userID)
        .order("created_at", ascending: false);

    // Update announcements in provider
    Provider.of<AnnouncementProvider>(context, listen: false)
        .setMyAnnouncements(adata);
    setState(() {
      announcements = adata;
    });
    setState(() {
      _bio = userdata[0]["bio"] ?? "";
      _bname = userdata[0]["business_name"] ?? "";
      _pname = userdata[0]["public_name"] ?? "";
      _website = userdata[0]["website"] ?? "";
      _cname = userdata[0]["community_name"] ?? "";
      _isLoding = false;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
    return;
  }

  // MARK: Image picker
  void _pickImage(ImageSource source, ProfileProvider profileProvider) async {
    prefs = await SharedPreferences.getInstance();
    final pickedFile = await _picker.pickImage(source: source);
    _showProgressModal(context);
    supabase = Supabase.instance.client;
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final String fullPath = await supabase.storage.from('avatars').upload(
            "${DateTime.now().microsecondsSinceEpoch}",
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      await supabase.from('members').update(
        {"avatar_url": fullPath},
      ).eq("id", prefs.getString("userID")!);
      // print("donwload url:\n$fullPath");
      profileProvider.avatar = fullPath;
      prefs.setString("avatar", fullPath);
      setState(() {
        _avatar = prefixURL + fullPath;
      });
      Navigator.of(context).pop();
    } else {
      print('No image selected.');
    }
  }

  void _showPicker(context, profileProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery, profileProvider);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera, profileProvider);
                  Navigator.of(context).pop();
                },
              ),
            ],
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

  //MARK: Delete announcement
  void _deleteAnnnouncement(index, id) async {
    _showProgressModal(context);
    final temp = announcements;
    print(temp.length);
    temp.removeAt(index);
    setState(() {
      announcements = temp;
    });
    print(announcements.length);
    // supabase = Supabase.instance.client;
    // await supabase.from("community_logs").delete().eq("id", id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    if (profileProvider.avatar != "") {
      _avatar = prefixURL + profileProvider.avatar;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AnnouncementProvider>(
        builder: (context, announcementProvider, child) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  //MARK: User Info
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF5F0F0),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //MARK: Avatar
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showPicker(context, profileProvider);
                                    },
                                    child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: _avatar == ""
                                            ? Container(
                                                color: Colors.white,
                                                child: AspectRatio(
                                                  aspectRatio: 1.6,
                                                  child: BlurHash(
                                                    hash:
                                                        'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                  ),
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: _avatar,
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
                                ),
                                // Positioned(
                                //   top: 57,
                                //   left: 64,
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       _showPicker(context, profileProvider);
                                //     },
                                //     child: Container(
                                //       width: 16,
                                //       height: 16,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(8),
                                //         color: Color(0xFFDDDDDD),
                                //       ),
                                //       child: Icon(
                                //         Ionicons.camera_outline,
                                //         size: 8,
                                //         color: Color(0xFF17181A),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        //MARK: userinfo-public name
                        _isLoding == true
                            ? Skeletonizer(
                                child: Text(
                                  "Full Stack Developer",
                                  style: TextStyle(
                                    fontFamily: "Lastik-test",
                                    fontSize: 24,
                                    height: 1.42,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF101010),
                                  ),
                                ),
                              )
                            : Text(
                                _pname,
                                style: TextStyle(
                                  fontFamily: "Lastik-test",
                                  fontSize: 24,
                                  height: 1.42,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF101010),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _bio,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              height: 1.47,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        // MARK: userinfo-business name
                        _isLoding == true
                            ? Skeletonizer(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "Seasoned senior full stack developer",
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          height: 1.47,
                                          color: APP_BLACK_COLOR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  if (_bname.isNotEmpty)
                                    Icon(
                                      Ionicons.briefcase_outline,
                                      size: 14,
                                      color: Color(0xFF898A8D),
                                    ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    _bname,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 100,
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        height: 1.47,
                                        color: APP_BLACK_COLOR,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 6,
                        ),
                        // MARK: userinfo-community name
                        _isLoding == true
                            ? Skeletonizer(
                                child: Row(
                                  children: [
                                    if (_cname.isNotEmpty)
                                      Icon(
                                        Ionicons.location_outline,
                                        size: 14,
                                        color: Color(0xFF898A8D),
                                      ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "Developer/Design Farm",
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          height: 1.47,
                                          color: APP_BLACK_COLOR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  if (_cname.isNotEmpty)
                                    Icon(
                                      Ionicons.location_outline,
                                      size: 14,
                                      color: Color(0xFF898A8D),
                                    ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    _cname,
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        height: 1.47,
                                        color: APP_BLACK_COLOR,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 6,
                        ),
                        // MARK: userinfo-website
                        _isLoding == true
                            ? Skeletonizer(
                                child: Row(
                                  children: [
                                    if (_website.isNotEmpty)
                                      Icon(
                                        Ionicons.link,
                                        size: 14,
                                        color: Color(0xFF898A8D),
                                      ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        "www.example.com",
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            height: 1.47,
                                            color: Color(0xFFAAD130),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  if (true)
                                    Icon(
                                      Ionicons.link,
                                      size: 14,
                                      color: Color(0xFF898A8D),
                                    ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (await canLaunchUrl(
                                        Uri.parse(
                                            "https://${_website.replaceAll("https://", "")}"),
                                      )) {
                                        await launchUrl(
                                          Uri.parse(
                                            "https://${_website.replaceAll("https://", "")}",
                                          ),
                                        );
                                      } else {
                                        showAppToast(
                                            context, "Link format is invalid");
                                      }
                                    },
                                    child: Text(
                                      _website,
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          height: 1.47,
                                          color: Color(0xFFAAD130),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 14,
                        ),
                        //MARK: Button group
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/edit-profile');
                              },
                              child: Container(
                                width: 180,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFFE2E2E2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "Edit Profile",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      height: 1.6,
                                      color: APP_MAIN_LABEL_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Container(
                            //       width: 40,
                            //       height: 40,
                            //       alignment: Alignment.center,
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(20),
                            //         border: Border.all(
                            //           color: Color(0xFFE2E2E2),
                            //           width: 1,
                            //         ),
                            //       ),
                            //       child: SvgPicture.asset(
                            //         "assets/images/send.svg",
                            //         width: 20,
                            //         height: 20,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 16,
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         Supabase.instance.client.auth.signOut();
                            //         Navigator.pushReplacementNamed(
                            //           context,
                            //           "/sign-in",
                            //         );
                            //       },
                            //       child: Container(
                            //         width: 40,
                            //         height: 40,
                            //         alignment: Alignment.center,
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(20),
                            //           border: Border.all(
                            //             color: Color(0xFFE2E2E2),
                            //             width: 1,
                            //           ),
                            //         ),
                            //         child: SvgPicture.asset(
                            //           "assets/images/right_arrow.svg",
                            //           width: 20,
                            //           height: 20,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  //MARK: Announcement List
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: announcementProvider.myAnnouncements.length,
                    itemBuilder: (context, index) {
                      return UserAnnouncementCard(
                        id: announcementProvider.myAnnouncements[index]["id"],
                        index: index,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavbar(
        index: 2,
      ),
    );
  }
}
