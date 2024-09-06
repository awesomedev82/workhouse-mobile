import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:workhouse/utils/profile_provider.dart';

class AppBottomNavbar extends StatefulWidget {
  const AppBottomNavbar({Key? key}) : super(key: key);

  @override
  _AppBottomNavbarState createState() => _AppBottomNavbarState();
}

class _AppBottomNavbarState extends State<AppBottomNavbar> {
  late SharedPreferences prefs;
  late SupabaseClient supabase;
  String avatar = "";
  String prefixURL =
      "https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("userID")!;
    supabase = Supabase.instance.client;
    setState(() {
      avatar = prefixURL + prefs.getString("avatar")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    if (profileProvider.avatar != "") {
      avatar = prefixURL + profileProvider.avatar;
    }
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
              onTap: () {
                Navigator.of(context).pushNamed('/community');
              },
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
              onTap: () {
                Navigator.of(context).pushNamed('/account');
              },
              child: avatar == ""
                  ? Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFF898A8D),
                      ),
                    )
                  : SizedBox(
                      height: 24,
                      width: 24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
