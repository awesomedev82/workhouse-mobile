import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFDEE0E3), width: 1),
          ),
          child: Row(
            children: [
              // Prefix icon with background color
              if (widget.prefix != null)
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xFFE3FAFF), // Light green background
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  // padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/w.svg",
                          //height: 15,
                        ),
                        SizedBox(width: 4), // Space between icon and text
                        Text(
                          "www.",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF006766),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.prefix != null)
                // Vertical Divider
                Container(
                  width: 1,
                  height: 55,
                  color: Color(0xFFDEE0E3),
                ),

              // Text Field
              Expanded(
                child: TextField(
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
                      color: Colors.black,
                    ),
                  ),
                  decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF7D7E83),
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      constraints: BoxConstraints(maxHeight: widget.maxHeight)),
                  onChanged: (value) {
                    setState(() {
                      isTyping = value.isNotEmpty;
                      widget.validate(value);
                    });
                  },
                  onSubmitted: widget.validate,
                  obscureText: isPasswordShow,
                  enableSuggestions: !isPasswordShow,
                  autocorrect: !isPasswordShow,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
