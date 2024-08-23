import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workhouse/components/app_button.dart';
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
                height: 15,
              ),
              DefaultTextStyle(
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: APP_MAIN_LABEL_COLOR,
                  ),
                ),
                child: Text(
                  'We use mobile authentication to keep our app safe and secure.',
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                ),
              ),
              AppButton(),    
            ],
          ),
        ),
      ),
    );
  }
}
