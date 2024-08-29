import 'package:flutter/material.dart';
import 'package:workhouse/utils/constant.dart';

class AppBottomNavbar extends StatefulWidget {
  const AppBottomNavbar({Key? key}) : super(key: key);

  @override
  _AppBottomNavbarState createState() => _AppBottomNavbarState();
}

class _AppBottomNavbarState extends State<AppBottomNavbar> {
  int _selectedIndex = 0;

  // List of widgets to display for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 34, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFEAE6E6), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 24,
                width: 24,
                child: Image.asset('assets/images/home.png'),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 24,
                width: 24,
                child: Image.asset('assets/images/search.png'),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 24,
                width: 24,
                child: Image.asset('assets/images/ellipse.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
