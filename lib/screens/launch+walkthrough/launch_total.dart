import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/launch_slider_indicator.dart';
import 'package:workhouse/screens/launch+walkthrough/launch_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_first_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_fouth_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_second_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_third_screen.dart';
import 'package:workhouse/utils/constant.dart';

class LaunchTotal extends StatefulWidget {
  const LaunchTotal({Key? key}) : super(key: key);

  @override
  _LaunchTotalState createState() => _LaunchTotalState();
}

class _LaunchTotalState extends State<LaunchTotal> {
  final List<Widget> _screens = [
    LaunchScreen(),
    WalkFirstScreen(),
    WalkSecondScreen(),
    WalkThirdScreen(),
    // WalkFouthScreen(),
  ];
  int _current = 0;

  late SharedPreferences prefs;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    bool visited = prefs.getBool("visited") ?? false;
    if (visited == true) {
      onNext();
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void onNext() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("visited", true);
    String userID = prefs.getString("userID") ?? "";
    String username = prefs.getString("username") ?? "";
    String fullname = prefs.getString("fullname") ?? "";
    String businessName = prefs.getString("businessName") ?? "";
    if (userID.isEmpty) {
      Navigator.pushReplacementNamed(context, '/sign-in');
    } else if (fullname.isEmpty) {
      Navigator.pushReplacementNamed(context, '/add-directory');
    } else {
      Navigator.pushReplacementNamed(context, '/community');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: Image.asset(
                "assets/images/appicon.png",
                width: 96,
                height: 96,
              ),
            ),
          )
        : Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    FlutterCarousel(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        // aspectRatio: 1,
                        showIndicator: false,
                        autoPlay: false,
                        disableCenter: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      items: [0, 1, 2, 3].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              child: _screens[i],
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 48,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppButton(
                          text: "Get started",
                          onTapped: () async {
                            onNext();
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          //Slider Indicator
                          child: LaunchSliderIndicator(index: _current),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
