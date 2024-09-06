import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/otp_input.dart';
import 'package:workhouse/components/page_indicator.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Create Account Screen UI Widget Class
 */

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String fullname = "";
  String phonenumber = "";
  String validateText = "";
  late SharedPreferences prefs;
  late SupabaseClient supabase;

  Future<bool> validateInputs() async {
    if (fullname.isEmpty) {
      validateText = "Input Full Name";
      CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        title: Text(
          validateText,
          style: TextStyle(color: Colors.red[600]),
        ),
      ).show(context);
      return false;
    } else if (phonenumber.isEmpty ||
        !RegExp(r'^\d{3}\.\d{3}\.\d{4}$').hasMatch(phonenumber)) {
      validateText = "Input Correct Phonenumber";
      CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        title: Text(
          validateText,
          style: TextStyle(color: Colors.red[600]),
        ),
      ).show(context);
      return false;
    } else {
      prefs = await SharedPreferences.getInstance();
      prefs.setString("fullname", fullname);
      prefs.setString("phonenumber", phonenumber);
      supabase = Supabase.instance.client;

      String uid = prefs.getString("userID") ?? "";
      if (uid.isNotEmpty) {
        _showCustomModal(context);
        try {
          await supabase.from('members').update(
            {"full_name": fullname, "phone": phonenumber},
          ).eq("id", uid);
          Navigator.of(context).pop();
          return true;
        } catch (e) {
          print(e);
          CherryToast.error(
            animationDuration: Duration(milliseconds: 300),
            title: Text(
              "Error occured during the execution!",
              style: TextStyle(color: Colors.red[600]),
            ),
          ).show(context);
          Navigator.of(context).pop();
          return false;
        }
      } else {
        CherryToast.error(
          animationDuration: Duration(milliseconds: 300),
          title: Text(
            "Error occured during the execution!",
            style: TextStyle(color: Colors.red[600]),
          ),
        ).show(context);
        return false;
      }
    }
  }

  void _showCustomModal(BuildContext context) {
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
                    PageIndicator(index: 1),
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
                      ),
                      child: Text(
                        'Create Account',
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
                        'Welcome to Workhouse!The app made for co-working communities.',
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // MARK: Full Name
                    Text(
                      "Full Name",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppInput(
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
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppInput(
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
                    AppButton(
                      text: "Continue",
                      onTapped: () async {
                        if (await validateInputs()) {
                          Navigator.pushNamed(context, "/add-directory");
                        } else {}
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
