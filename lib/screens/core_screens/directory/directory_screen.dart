import 'package:flutter/material.dart';
import 'package:workhouse/components/app_bottom_navbar.dart';
import 'package:workhouse/components/header_bar.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Directory Screen UI Widget Class
 */

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({Key? key}) : super(key: key);

  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: APP_WHITE_COLOR,
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                HeaderBar(title: "Directory"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavbar(
        index: 1,
      ),
    );
  }
}
