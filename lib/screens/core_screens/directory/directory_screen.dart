import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_bottom_navbar.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/header_bar.dart';
import 'package:workhouse/components/skeleton_component.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Directory Screen UI Widget Class
 */

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({Key? key}) : super(key: key);

  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _searchValue = "";
  List<dynamic> _searchResult = <dynamic>[];
  late SupabaseClient supabase;
  late SharedPreferences prefs;
  bool _isLoading = true;
  FocusNode _focusNode = FocusNode();

  // Track the focus state
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      bool _isLoading = true;
    });
    init();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  void init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showProgressModal(context);
    });
    final supabase = Supabase.instance.client;
    final prefs = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 1000), () {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _searchMembers() async {
    final supabase = Supabase.instance.client;
    final prefs = await SharedPreferences.getInstance();
    final communityID = prefs.getString("communityID")!;
    final userID = prefs.getString("userID")!;
    print(communityID);
    dynamic response;
    if (_searchValue.isNotEmpty) {
      response = await supabase
          .from('members')
          .select()
          .or('full_name.ilike.%$_searchValue%,public_name.ilike.%$_searchValue%')
          .not('id', 'eq', userID)
          .eq("community_id", communityID);
    }
    setState(() {
      _searchResult = response ?? [];
    });
  }

  void selectMember(id) async {
    print(id);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedMemberID", id);
    Navigator.of(context).pushNamed('/selected-member');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: APP_WHITE_COLOR,
        ),
        child: Container(
          child: Column(
            children: [
              _isLoading
                  ? Skeletonizer(
                      child: Container(
                        height: 95,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFEAE6E6),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hello World Hello World",
                              style: TextStyle(
                                fontFamily: "Lastik-test",
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: APP_BLACK_COLOR,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : HeaderBar(title: "Directory"),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isLoading
                            ? Skeletonizer(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 28),
                                      width: double.infinity,
                                      height: 68,
                                      child: Image.asset(
                                        width: double.infinity,
                                        height: 180,
                                        "assets/images/carousel-1.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // MARK: Full Name
                                    // Text(
                                    //   "Search",
                                    //   style: GoogleFonts.inter(
                                    //     textStyle: TextStyle(
                                    //       fontWeight: FontWeight.w300,
                                    //       fontSize: 14,
                                    //       color: Color(0xFF17181A),
                                    //       height: 1.6,
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    TextField(
                                      maxLines: 1,
                                      // controller: controller,
                                      showCursor: true,
                                      cursorColor:
                                          Color.fromARGB(255, 71, 71, 71),
                                      cursorWidth: 1,
                                      cursorHeight: 20,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Search",
                                        hintStyle: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Color(0xFF7D7E83)),
                                        ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            "assets/images/person_search.svg",
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFDDDDDD),
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFDDDDDD),
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFDEE0E3),
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        constraints: BoxConstraints(
                                          maxHeight: 44,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 16,
                                        ),
                                      ),
                                      // MARK: onChanged
                                      onChanged: (value) {
                                        setState(() {
                                          _searchValue = value;
                                        });
                                        _searchMembers();
                                      },
                                      // MARK: onSubmitted
                                      onSubmitted: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 12,
                        ),
                        //Result
                        Container(
                          width: double.infinity,
                          child: _searchValue.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 104,
                                    ),
                                    Container(
                                      width: 260,
                                      height: 208,
                                      child: SvgPicture.asset(
                                        "assets/images/search_directory.svg",
                                      ),
                                    ),
                                  ],
                                )
                              : _searchResult.length == 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 104,
                                        ),
                                        Container(
                                          width: 260,
                                          height: 208,
                                          child: SvgPicture.asset(
                                            "assets/images/search_no_result.svg",
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: _searchResult.length,
                                          itemBuilder: (context, index) {
                                            final member = _searchResult[index];
                                            return GestureDetector(
                                              onTap: () {
                                                selectMember(member["id"]);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 78,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 16,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Color(0xFFF5F0F0),
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 46,
                                                      height: 46,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        child: Image.network(
                                                          "https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/${member["avatar_url"]}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              member[
                                                                  "full_name"],
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Lastik-test",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16,
                                                                height: 1.4,
                                                              ),
                                                            ),
                                                            Text(
                                                              member[
                                                                  "public_name"],
                                                              style: GoogleFonts
                                                                  .inter(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 14,
                                                                  height: 1.42,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavbar(
        index: 1,
      ),
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
}
