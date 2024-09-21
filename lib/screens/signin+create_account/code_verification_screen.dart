import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/app_progress_indicator.dart';
import 'package:workhouse/components/app_toast.dart';
import 'package:workhouse/components/otp_input.dart';
import 'package:workhouse/components/page_indicator.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:workhouse/utils/profile_provider.dart';

/**
 * MARK: Code Verification Screen UI Widget Class
 */

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({Key? key}) : super(key: key);

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  String _otpcode = "";
  late SharedPreferences prefs;
  String _emailAddress = "";
  late SupabaseClient supabase;

  void _onCodeChanged(String? newValue) {
    setState(() {
      _otpcode = newValue ?? "";
    });
  }

  //MARK: Verify OTP
  void verifyOTP(ProfileProvider profileProvider) async {
    print(_otpcode);
    _showProgressModal(context);
    prefs = await SharedPreferences.getInstance();
    _emailAddress = prefs.getString("email")!;
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: _emailAddress,
        token: _otpcode,
        type: OtpType.email,
      );
      prefs.setString("userID", response.user?.id ?? "");
      supabase = Supabase.instance.client;
      final data = await supabase
          .from("member_community_view")
          .select()
          .eq("id", response.user!.id);

      // Add active listener
      supabase
          .from("members")
          .stream(primaryKey: ['id'])
          .eq("id", response.user!.id)
          .listen((payload) {
            final newRecord = payload.first;
            if (newRecord['is_active'] == false) {
              Supabase.instance.client.auth.signOut();
              showAppToast(context, "Your account was deactivated!");
              Navigator.pushReplacementNamed(context, "/sign-in");
            }
          });

      print(data[0]);
      String fullname = data[0]["full_name"] ?? "";
      String businessName = data[0]["business_name"] ?? "";
      String communityID = data[0]["community_id"] ?? "";
      String avatar = data[0]["avatar_url"] ?? "";
      print("$fullname, $businessName, $communityID");
      prefs.setString("fullname", fullname);
      prefs.setString("businessName", businessName);
      prefs.setString("communityID", communityID);
      prefs.setString("avatar", avatar);
      profileProvider.avatar = avatar;

      if (fullname.isEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/add-directory");
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/community");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showAppToast(context, "Code is incorrect or expired!");
      print("Error:$e");
    }
  }

  //MARK: Resend code
  void _resendCode() async {
    try {
      prefs = await SharedPreferences.getInstance();
      _emailAddress = prefs.getString("email") ?? "";
      final response = await Supabase.instance.client.auth.signInWithOtp(
        email: _emailAddress,
      );
      showAppToast(context, "New code was sent!");
    } catch (e) {
      showAppToast(context, "Error occured, please try again!");
    }
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
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: APP_WHITE_COLOR,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 64,
                    ),
                    PageIndicator(index: 0),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 27,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: "Lastik-test",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: APP_MAIN_LABEL_COLOR,
                        height: 1.42,
                      ),
                      child: Text(
                        'Verification Code',
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    DefaultTextStyle(
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: APP_MAIN_LABEL_COLOR,
                          height: 1.6,
                        ),
                      ),
                      child: Text(
                        'Enter the passcode sent to your phone number.',
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    // MARK: OTP Input
                    OtpInput(codeChanged: _onCodeChanged),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn’t received code?  ",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 12,
                                height: 1.6,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              _resendCode();
                            },
                            child: Text(
                              "Resend Code",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Color(0xFFE55733),
                                  fontSize: 12,
                                  height: 1.6,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    AppButton(
                      text: "Login",
                      onTapped: () {
                        verifyOTP(profileProvider);
                      },
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
