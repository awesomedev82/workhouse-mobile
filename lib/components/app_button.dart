import 'package:flutter/material.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: App Button Widget Class
 */

class AppButton extends StatefulWidget {
  const AppButton({Key? key}) : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: APP_BLACK_COLOR,
      ),
      child: Align(
        alignment: Alignment.center,
        child: DefaultTextStyle(
          child: Text('Login'),
          style: TextStyle(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
