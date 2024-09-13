import 'dart:io';
import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:open_mail_app/open_mail_app.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({Key? key}) : super(key: key);

  @override
  _CheckEmailState createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  String emailAddress = "";
  String phoneValidText = "";
  late SharedPreferences prefs;
  late SupabaseClient supabase;

  Future<bool> validateemailAddress() async {
    _showProgressModal(context);
    if (emailAddress.isEmpty) {
      setState(() {
        phoneValidText = "Please enter a email address";
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
          phoneValidText = "Email doesn't exist!";
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

  // MARK: Launch Email App
  Future<void> _launchEmailApp() async {
    var result = await OpenMailApp.openMailApp();
    Navigator.of(context).pushNamed('/code-verification');
    // If no mail apps found, show error
    if (!result.didOpen && !result.canOpen) {
      showNoMailAppsDialog(context);

      // iOS: if multiple mail apps found, show dialog to select.
      // There is no native intent/default app system in iOS so
      // you have to do it yourself.
    } else if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        builder: (_) {
          return MailAppPickerDialog(
            mailApps: result.options,
          );
        },
      );
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
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
            horizontal: 27,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 84,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset("assets/images/arrow-left.svg"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
                      'Check your email',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 214,
                      width: 214,
                      child: SvgPicture.asset(
                        'assets/images/check-email.svg',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "To confirm your email address copy the code we sent to your email address. Don’t forget to check your spam and junk folder as well.",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              AppButton(
                text: "Open email app",
                onTapped: () async {
                  await _launchEmailApp();
                },
                color: 0xFF014E53,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
