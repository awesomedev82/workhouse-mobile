import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_control_input.dart';
import 'package:workhouse/components/app_dropdown.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/utils/announcement_provider.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Edit Profile Screen UI Widget Class
 */

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String fullname = "";
  String phonenumber = "";
  String businessName = "";
  String bio = "";
  String website = "";
  String publicName = "";
  String industry = "Architecture";
  String validateText = "";
  String userID = "";
  bool isLoading = false;
  late SharedPreferences prefs;
  late SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getData();
  }

  void getData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showProgressModal(context);
    });
    supabase = Supabase.instance.client;
    prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("userID")!;
    final userData =
        await supabase.from("members").select().eq("id", userID).single();
    print(userData);

    setState(() {
      fullname = userData["full_name"];
      phonenumber = userData["phone"] ?? "";
      businessName = userData["business_name"];
      publicName = userData["public_name"];
      website = userData["website"];
      industry = userData["industry"] ?? "Architecture";
      bio = userData["bio"] ?? "";
      isLoading = false;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
    return;
  }

  void _onIndustrySelected(String? newValue) {
    setState(() {
      industry = newValue ?? "";
    });
  }

  void onSave() async {
    _showProgressModal(context);
    await supabase.from("members").update({
      "full_name": fullname,
      "phone": phonenumber,
      "website": website,
      "public_name": publicName,
      "business_name": businessName,
      "bio": bio,
      "industry": industry,
    }).eq("id", userID);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed("/account");
  }

  void onSignout() async {
    print("signout");
    Supabase.instance.client.auth.signOut();
    prefs = await SharedPreferences.getInstance();
    prefs.setString("userID", "");
    Navigator.pushReplacementNamed(
      context,
      "/sign-in",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: isLoading == false
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE9EAEC)),
                            child: SvgPicture.asset(
                                "assets/images/arrow-left.svg")),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Edit Profile",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Lastik-test",
                          fontSize: 24,
                          height: 1.62,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              child: GestureDetector(
                                onTap: () {
                                  // Handle onTap action here if needed
                                },
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.asset(
                                      'assets/images/search.png', // Replace with the path to your static image
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // MARK: Full Name
                        Text(
                          "Full Name",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF14151A),
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppControlInput(
                          defaultText: fullname,
                          hintText: "Full Name",
                          validate: (val) {
                            setState(() {
                              fullname = val;
                            });
                          },
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // MARK: Phone Number
                        Text(
                          "Phone Number",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF14151A),
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppControlInput(
                          defaultText: phonenumber,
                          hintText: "123.123.1234",
                          validate: (val) {
                            setState(() {
                              phonenumber = val;
                            });
                          },
                          inputType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // MARK: Business Name
                        Text(
                          "Business Name",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF14151A),
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppControlInput(
                          defaultText: businessName,
                          hintText: "",
                          validate: (val) {
                            setState(() {
                              businessName = val;
                            });
                          },
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // MARK: Bio
                        Text(
                          "Bio",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF14151A),
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppControlInput(
                          defaultText: bio,
                          hintText: "",
                          validate: (val) {
                            setState(() {
                              bio = val;
                            });
                          },
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // MARK: Website
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Website ",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(
                                        0xFF14151A), // Main color for "Website"
                                    height: 1.6,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: "(optional)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFF0D1126).withOpacity(
                                        0.6), // Color with 0.6 opacity
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
                        AppControlInput(
                          prefix: "",
                          defaultText: website,
                          hintText: "",
                          validate: (val) {
                            setState(() {
                              website = val;
                            });
                          },
                          inputType: TextInputType.url,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // MARK: Publick name
                        Text(
                          "Public Name",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF14151A),
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppControlInput(
                          defaultText: publicName,
                          hintText:
                              "Will show up as your public name on the app",
                          validate: (val) {
                            setState(() {
                              publicName = val;
                            });
                          },
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/images/error.svg"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Your user name will be visible on the app",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF0D1126).withOpacity(0.4),
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // MARK: Industry
                        Text(
                          "Industry",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF14151A),
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppDropdown(
                          items: [
                            'Architecture',
                            'Advertising and Marketing',
                            'Art and Illustration',
                            'Audio Production',
                            'Beauty and Cosmetics',
                            'Blogging and Content Creation',
                            'Brewing and Distilling',
                            'Catering and Food Services',
                            'Ceramics and Pottery',
                            'Coaching and Consulting',
                            'Commercial Photography',
                            'Dance and Choreography',
                            'E-commerce',
                            'Event Planning and Management',
                            'Fashion Design',
                            'Film and Video Production',
                            'Fitness and Wellness',
                            'Floristry',
                            'Freelancer',
                            'Game Development',
                            'Graphic Design',
                            'Handmade Goods',
                            'Interior Design',
                            'Jewelry Making',
                            'Landscape Design',
                            'Music Production',
                            'Painting and Fine Arts',
                            'Personal Styling',
                            'Pet Services',
                            'Podcasting',
                            'Print and Publishing',
                            'Product Design',
                            'Public Relations',
                            'Real Estate',
                            'Social Media Management',
                            'Software Development',
                            'Sustainable and Eco-friendly Products',
                            'Tattoo and Body Art',
                            'Theater and Performing Arts',
                            'Translation and Interpretation',
                            'UX/UI Design',
                            'Web Development',
                            'Professional  Services',
                            'Woodworking and Carpentry',
                            'Yoga and Meditation Instruction',
                            'Other',
                          ],
                          initialValue: industry,
                          onItemSelected: _onIndustrySelected,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/images/error.svg"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Select the industry that describes you ",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF0D1126).withOpacity(0.4),
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        AppButton(
                          text: "Save",
                          onTapped: () {
                            onSave();
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 49,
                          decoration: BoxDecoration(),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              side: BorderSide(
                                color: APP_BLACK_COLOR,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width - 40, 43),
                              elevation: 0.8,
                            ),
                            onPressed: () {
                              onSignout();
                            },
                            onLongPress: () => {},
                            child: Text(
                              "Sign out",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: APP_BLACK_COLOR,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  height: 1.21,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            :
            // MARK: skeleton UI
            Skeletonizer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 44,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE9EAEC)),
                              child: SvgPicture.asset(
                                  "assets/images/arrow-left.svg")),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Skeletonizer(
                          child: Text(
                            "Edit Profile",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Lastik-test",
                              fontSize: 32,
                              // height: 1.62,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            height: 68,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                width: double.infinity,
                                height: 180,
                                "assets/images/carousel-1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
