import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workhouse/utils/constant.dart';

/**
 * MARK: Edit Announcement Screen UI Widget Class
 */

class EditAnnouncementScreen extends StatefulWidget {
  const EditAnnouncementScreen({Key? key}) : super(key: key);

  @override
  _EditAnnouncementScreenState createState() => _EditAnnouncementScreenState();
}

class _EditAnnouncementScreenState extends State<EditAnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 28,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 44,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 2,
                ),
                child: SvgPicture.asset("assets/images/arrow-left.svg"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
