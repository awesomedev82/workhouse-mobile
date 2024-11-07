import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workhouse/utils/constant.dart';
/**
 * MARK: App Input Widget Class
 */

class AppControlInput extends StatefulWidget {
  const AppControlInput({
    Key? key,
    required this.hintText,
    required this.defaultText,
    this.obscureText = false,
    this.inputType = TextInputType.name,
    required this.validate,
    this.isSeconderyIcon = false,
    this.maxLines = 1,
    this.maxHeight = 44,
    this.prefix,
  }) : super(key: key);

  final String hintText;
  final String defaultText;
  final bool obscureText;
  final TextInputType inputType;
  final Function(String) validate;
  final bool isSeconderyIcon;
  final int maxLines;
  final double maxHeight;
  final String? prefix;

  @override
  _AppControlInputState createState() => _AppControlInputState();
}

class _AppControlInputState extends State<AppControlInput> {
  bool isPasswordShow = false;
  bool isTyping = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    isPasswordShow = widget.obscureText;
    setState(() {
      controller.text = widget.defaultText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          maxLines: widget.maxLines,
          controller: controller,
          showCursor: true,
          cursorColor: Color.fromARGB(255, 71, 71, 71),
          cursorWidth: 1,
          cursorHeight: 20,
          keyboardType: widget.inputType,
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: APP_BLACK_COLOR,
            ),
          ),
          decoration: InputDecoration(
            // prefix: widget.prefix != null
            //     ? SvgPicture.asset(
            //         widget.prefix ?? "assets/images/w.svg",
            //         width: 120,
            //         height: 40,
            //         //  color: Colors.grey,
            //       )
            //     : null,
            prefixIcon: widget.prefix != null
                ? Padding(
                    padding: const EdgeInsets.all(0),
                    child: SvgPicture.asset(
                      widget.prefix!,
                      width: 120,
                      height: 40,
                      //  color: Colors.grey,
                    ),
                  )
                : null,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF7D7E83)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDEE0E3), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDEE0E3), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          ),
          // MARK: onChanged
          onChanged: (value) {
            if (value == "") {
              setState(() {
                isTyping = false;
                widget.validate(value);
              });
            } else {
              setState(() {
                isTyping = true;
                widget.validate(value);
              });
            }
          },
          // MARK: onSubmitted
          onSubmitted: (value) {
            widget.validate(value);
          },
          obscureText: isPasswordShow,
          enableSuggestions: !isPasswordShow,
          autocorrect: !isPasswordShow,
        ),
      ],
    );
  }
}
