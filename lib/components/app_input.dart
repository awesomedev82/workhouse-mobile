import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
/**
 * MARK: App Input Widget Class
 */

class AppInput extends StatefulWidget {
  const AppInput(
      {Key? key,
      required this.hintText,
      this.obscureText = false,
      this.inputType = TextInputType.name,
      required this.validate,
      this.isSeconderyIcon = false,
      this.maxLines = 1,
      this.maxHeight = 44})
      : super(key: key);

  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final Function(String) validate;
  final bool isSeconderyIcon;
  final int maxLines;
  final double maxHeight;

  @override
  _AppInputState createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool isPasswordShow = false;
  bool isTyping = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    isPasswordShow = widget.obscureText;
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
          decoration: InputDecoration(
            suffixIcon: widget.obscureText
                ? InkWell(
                    child: isPasswordShow
                        ? Icon(Ionicons.eye_outline)
                        : Icon(Ionicons.eye_off_outline),
                    // MARK: show password icon click
                    onTap: () {
                      setState(() {
                        isPasswordShow = !isPasswordShow;
                      });
                    },
                  )
                : !widget.isSeconderyIcon
                    ? isTyping
                        ? InkWell(
                            child: Icon(Ionicons.remove_circle),
                            // MARK: clear icon click
                            onTap: () {
                              setState(() {
                                controller.text = "";
                                isTyping = false;
                              });
                            },
                          )
                        : Icon(null)
                    : InkWell(
                        child: Image.asset("assets/secondery_icon.png"),
                        // MARK: secondery icon click
                        onTap: () {},
                      ),
            suffixStyle: TextStyle(color: Colors.black.withAlpha(60)),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF7D7E83)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1),
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
