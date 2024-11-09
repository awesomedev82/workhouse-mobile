import 'package:flutter/material.dart';

class LaunchSliderIndicator extends StatefulWidget {
  final int index;

  const LaunchSliderIndicator({Key? key, required this.index})
      : super(key: key);

  @override
  _LaunchSliderIndicatorState createState() => _LaunchSliderIndicatorState();
}

class _LaunchSliderIndicatorState extends State<LaunchSliderIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...[0, 1, 2, 3].map((val) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              width: val == widget.index ? 15 : 7.5,
              decoration: BoxDecoration(
                color: val == widget.index
                    ? Colors.black
                    : Color(0xFF014E53).withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
