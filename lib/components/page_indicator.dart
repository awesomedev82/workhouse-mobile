import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Row(
            children: [
              if (widget.index != 1)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container( padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE9EAEC)),
                    child: SvgPicture.asset(
                      'assets/images/arrow-left.svg',
                      
                    ),
                  ),
                ),
            ],
          ),
          if (widget.index != 0)
            Positioned(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 113,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFFE55733).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        if (widget.index == 1)
                          Positioned(
                            child: Container(
                              width: 47,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFFE55733).withOpacity(1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 113,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFFE55733).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        if (widget.index == 2)
                          Positioned(
                            child: Container(
                              width: 47,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFFE55733).withOpacity(1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
