import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_button.dart';
import 'package:workhouse/components/app_dropdown.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/otp_input.dart';
import 'package:workhouse/components/page_indicator.dart';
import 'package:workhouse/utils/constant.dart';

class AddDirectory extends StatefulWidget {
  const AddDirectory({Key? key}) : super(key: key);

  @override
  _AddDirectoryState createState() => _AddDirectoryState();
}

class _AddDirectoryState extends State<AddDirectory> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String businessName = "";
  String website = "";
  String publicName = "";
  String industry = "Arts";
  String company = "None";
  String imgURL = "";
  late SupabaseClient supabase;
  late SharedPreferences prefs;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onIndustrySelected(String? newValue) {
    setState(() {
      industry = newValue ?? "";
    });
  }

  void _onCompanySelected(String? newValue) {
    setState(() {
      company = newValue ?? "";
    });
  }

  void onNext() async {
    if (businessName.isEmpty) {
      CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        title: Text(
          "Enter business name!",
          style: TextStyle(color: Colors.red[600]),
        ),
      ).show(context);
    } else if (publicName.isEmpty) {
      CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        title: Text(
          "Enter public name!",
          style: TextStyle(color: Colors.red[600]),
        ),
      ).show(context);
    } else if (_image == null) {
      CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        title: Text(
          "Upload avatar!",
          style: TextStyle(color: Colors.red[600]),
        ),
      ).show(context);
    } else {
      _showCustomModal(context);
      prefs = await SharedPreferences.getInstance();
      prefs.setString("businessName", businessName);
      prefs.setString("publicName", publicName);
      supabase = Supabase.instance.client;

      String uid = prefs.getString("userID")!;

      try {
        final String fullPath = await supabase.storage.from('avatars').upload(
              "${DateTime.now().microsecondsSinceEpoch}.jpg",
              _image!,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );

        imgURL = fullPath;
      } catch (e) {
        print("image upload error:\n$e");
        CherryToast.error(
          animationDuration: Duration(milliseconds: 300),
          title: Text(
            "Some error occured!",
            style: TextStyle(color: Colors.red[600]),
          ),
        ).show(context);
      }
      print("imgURL:$imgURL");
      prefs.setString("avatar", imgURL);
      try {
        await supabase.from('members').update({
          "bio": businessName,
          "public_name": publicName,
          "website": imgURL,
          "industry": industry,
          "company_name": company,
        }).eq("id", uid);
        Navigator.pushReplacementNamed(context, "/community");
      } catch (e) {
        Navigator.of(context).pop();
        CherryToast.error(
          animationDuration: Duration(milliseconds: 300),
          title: Text(
            "Some error occured!",
            style: TextStyle(color: Colors.red[600]),
          ),
        ).show(context);
      }
    }
  }

  void _showCustomModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LoadingAnimationWidget.hexagonDots(
                      color: Colors.blue, size: 32),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: APP_WHITE_COLOR,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 64,
                    ),
                    PageIndicator(index: 2),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 27,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: "Lastik-test",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: APP_MAIN_LABEL_COLOR,
                      ),
                      child: Text(
                        'Add to Directory',
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    DefaultTextStyle(
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: APP_MAIN_LABEL_COLOR,
                          height: 1.6,
                        ),
                      ),
                      child: Text(
                        'Lets add your information to the Workhouse directory.',
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    //MARK: Avatar Upload
                    Text(
                      "Add Profile Image",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[200],
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // MARK: Business Name
                    Text(
                      "Business Name",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppInput(
                      hintText: "",
                      validate: (val) {
                        setState(() {
                          businessName = val;
                        });
                      },
                      inputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // MARK: Website
                    Text(
                      "Website (optional)",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppInput(
                      hintText: "",
                      validate: (val) {
                        setState(() {
                          website = val;
                        });
                      },
                      inputType: TextInputType.url,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // MARK: Publick name
                    Text(
                      "Public Username",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppInput(
                      hintText: "Will show up as your public name on the app",
                      validate: (val) {
                        setState(() {
                          publicName = val;
                        });
                      },
                      inputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // MARK: Industry
                    Text(
                      "Industry",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppDropdown(
                      items: [
                        'Arts',
                        'Make Up',
                        'Skincare',
                        'Visual Arts',
                        'Professional Services',
                        'Food & Drinks',
                        'Technology',
                      ],
                      initialValue: industry,
                      onItemSelected: _onIndustrySelected,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // MARK: Associated Co-Workspace
                    Text(
                      "Associated Co-Workspace",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xFF17181A),
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppDropdown(
                      items: [
                        'Brown Bear Studios',
                        'Decatur Street Studios',
                        'One Eyed Studios',
                        'None',
                      ],
                      initialValue: company,
                      onItemSelected: _onCompanySelected,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    AppButton(
                      text: "Create Account",
                      onTapped: () {
                        onNext();
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}