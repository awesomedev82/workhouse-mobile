import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/app_toast.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Sign In Screen UI Widget Class
 */
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String emailAddress = "";
  String phoneValidText = "";
  late SharedPreferences prefs;
  late SupabaseClient supabase;

  Future<bool> validateemailAddress() async {
    _showProgressModal(context);
    if (emailAddress.isEmpty) {
      setState(() {
        phoneValidText = "Please enter an email address";
      });
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(emailAddress)) {
      setState(() {
        phoneValidText = "Please enter a valid email address";
      });
      return false;
    } else {
      supabase = Supabase.instance.client;
      final data =
          await supabase.from("members").select().eq("email", emailAddress);

      print(data);
      if (data.isEmpty) {
        setState(() {
          phoneValidText = "Please use the email address from your invite";
        });
        return false;
      } else if (data[0]["is_active"] == false) {
        setState(() {
          phoneValidText = "You account was deactivated!";
        });
        return false;
      }
    }
    return true;
  }

  void sendOTP() async {
    final response = await Supabase.instance.client.auth.signInWithOtp(
      email: emailAddress,
    );
    prefs = await SharedPreferences.getInstance();
    prefs.setString("email", emailAddress);
    print(prefs.getString("email"));
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: APP_WHITE_COLOR,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 84,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // exit(0);
                      prefs = await SharedPreferences.getInstance();
                      prefs.setBool("visited", false);
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFE9EAEC)),
                        child:
                            SvgPicture.asset("assets/images/arrow-left.svg")),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              DefaultTextStyle(
                style: TextStyle(
                  fontFamily: "Lastik-test",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: APP_MAIN_LABEL_COLOR,
                  height: 1.42,
                ),
                child: Text(
                  'Sign in with email',
                ),
              ),
              DefaultTextStyle(
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F1324).withOpacity(0.6),
                    height: 1.6,
                  ),
                ),
                child: Text(
                  'Enter the email address associated with your Workhouse invite.',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // MARK: Email Address
              Text(
                "Email Address",
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
                height: 10,
              ),
              AppInput(
                hintText: "Enter your email",
                validate: (val) {
                  setState(() {
                    emailAddress = val;
                  });
                },
                inputType: TextInputType.emailAddress,
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
                    "We’ll send a code to your email to confirm your account",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
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
                text: "Sign in",
                onTapped: () async {
                  if (await validateemailAddress() == false) {
                    Navigator.of(context).pop();
                    showAppToast(context, phoneValidText);
                  } else {
                    Navigator.of(context).pop();
                    sendOTP();
                    Navigator.pushNamed(context, "/code-verification");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
