import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_input_editor/otp_input_editor.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    Key? key,
    required this.codeChanged,
  }) : super(key: key);

  final Function(String?) codeChanged;

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<bool> _isFocuseds = List.generate(6, (index) => false);
  String otpCode = '';

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          _isFocuseds[i] = _focusNodes[i].hasFocus;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChange(int i, String value) {
    // If the field is not empty and the current index is not the last field
    if (value.isNotEmpty) {
      _controllers[i].text =
          value; // Ensure the current controller has the value
      if (i < _focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
      }
    } else {
      // Handle backspace
      if (i > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
      }
    }

    // Update OTP Code
    otpCode = _controllers.map((controller) => controller.text).join();
    widget.codeChanged(otpCode);
  }

  Widget buildTextField(int i) {
    return Container(
      width: 48,
      height: 52,
      child: TextField(
        controller: _controllers[i],
        focusNode: _focusNodes[i],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        onChanged: (value) {
          _handleChange(i, value);
        },
        onTap: () {
          // No action required here now for clear
        },
        style: GoogleFonts.inter(
          textStyle: TextStyle(
            color: Color(0xFF02050F),
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        cursorColor: Color(0xFF7D7E83),
        cursorWidth: 1.5,
        cursorHeight: 20,
        decoration: InputDecoration(
          counterText: '',
          hintText: _isFocuseds[i] ? "" : "-",
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintStyle: GoogleFonts.inter(
            textStyle: TextStyle(
              color: Color(0xFFCBCBCB),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) => buildTextField(index)),
      ),
    );
  }
}
