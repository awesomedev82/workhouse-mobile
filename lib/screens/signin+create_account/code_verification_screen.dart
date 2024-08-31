import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/otp_input.dart';
import 'package:workhouse/components/page_indicator.dart';
import 'package:workhouse/utils/constant.dart';

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

  void verifyOTP() async {
    // print(_otpcode);
    prefs = await SharedPreferences.getInstance();
    _emailAddress = prefs.getString("email") ?? "";
    print(_emailAddress);
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: _emailAddress,
        token: _otpcode,
        type: OtpType.email,
      );
      prefs.setString("userID", response.user?.id ?? "");
      supabase = Supabase.instance.client;
      final data =
          await supabase.from("members").select().eq("id", response.user!.id);
      String fullname = data[0]["full_name"];
      String businessName = data[0]["bio"];
      prefs.setString("fullname", fullname);
      prefs.setString("businessName", businessName);
      print("$fullname, $businessName");
      if (fullname.isEmpty) {
        Navigator.pushReplacementNamed(context, "/create-account");
      } else if (businessName.isEmpty) {
        Navigator.pushReplacementNamed(context, "/add-directory");
      } else {
        // Navigator.pushReplacementNamed(context, "/add-directory");
        Navigator.pushReplacementNamed(context, "/community");
      }
    } catch (e) {
      CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        title: Text(
          "Code is incorrect or expired!",
          style: TextStyle(color: Colors.red[600]),
        ),
      ).show(context);
    }
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
                              prefs = await SharedPreferences.getInstance();
                              _emailAddress = prefs.getString("email") ?? "";
                              final response = await Supabase
                                  .instance.client.auth
                                  .signInWithOtp(
                                email: _emailAddress,
                              );
                              CherryToast.info(
                                animationDuration: Duration(milliseconds: 300),
                                title: Text(
                                  "New code was sent!",
                                  style: TextStyle(color: Colors.blue[600]),
                                ),
                              ).show(context);
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
                        verifyOTP();
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
