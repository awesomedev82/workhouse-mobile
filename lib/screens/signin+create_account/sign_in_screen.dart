import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Sign In Screen UI Widget Class
 */

final supabase = SupabaseClient("https://lgkqpwmgwwexlxfnvoyp.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxna3Fwd21nd3dleGx4Zm52b3lwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2NTUwNTAsImV4cCI6MjAzOTIzMTA1MH0.qiFcXbioNaggHs194TZJJS48hpbSvVssnhcnrIi7jbw");

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String emailAddress = "";
  String phoneValidText = "";
  late SharedPreferences prefs;

  bool validateemailAddress() {
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
              DefaultTextStyle(
                style: TextStyle(
                  fontFamily: "Lastik-test",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: APP_MAIN_LABEL_COLOR,
                ),
                child: Text(
                  'Sign In',
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
                  'We use mobile authentication to keep our app safe and secure.',
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
                hintText: "Enter your email",
                validate: (val) {
                  setState(() {
                    emailAddress = val;
                  });
                },
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 16,
              ),
              AppButton(
                text: "Login",
                onTapped: () {
                  if (validateemailAddress() == false) {
                    CherryToast.error(
                      animationDuration: Duration(milliseconds: 300),
                      title: Text(
                        phoneValidText,
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ).show(context);
                  } else {
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
