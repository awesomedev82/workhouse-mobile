import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToast extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onDismiss; // Callback to handle dismiss

  CustomToast({
    required this.message,
    required this.duration,
    required this.onDismiss,
  });

  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start fading in
    _animationController.forward();

    // Start fading out after the specified duration
    Future.delayed(widget.duration - Duration(milliseconds: 500), () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            widget.onDismiss(); // Call the onDismiss callback
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    widget.message,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    textAlign: TextAlign.left, // Center the text
                  ),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    _animationController.reverse().then((_) {
                      widget.onDismiss(); // Call the onDismiss callback
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
