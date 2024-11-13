import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/app_toast.dart';
import 'package:workhouse/components/app_video_player.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

/**
 * MARK: Share First Screen UI Widget Class
 */

class ShareFirstScreen extends StatefulWidget {
  const ShareFirstScreen({Key? key}) : super(key: key);

  @override
  _ShareFirstScreenState createState() => _ShareFirstScreenState();
}

class _ShareFirstScreenState extends State<ShareFirstScreen> {
  final FocusNode _nodeText = FocusNode();
  late SharedPreferences prefs;
  late SupabaseClient supabase;
  Map<String, dynamic>? paymentIntent;
  String _description = "";
  late VideoPlayerController? _videoController;

  List<Asset> images = <Asset>[];
  List<File> imagefiles = <File>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // MARK: Load Gallery Media
  void _loadMediaFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // final video = await picker.pickVideo(source: ImageSource.gallery);
    final medias = await picker.pickMultipleMedia();
    List<File> resultFiles = imagefiles;
    for (var media in medias) {
      final temp = File(media.path);
      if (lookupMimeType(media.path).toString().startsWith("video")) {
        _videoController = VideoPlayerController.file(temp);
        await _videoController?.initialize();

        if (_videoController!.value.duration.inSeconds > 60) {
          showAppToast(context, "Video length has to be less than 1min!");
          return;
        }
      }
      resultFiles.add(File(media.path));
    }
    setState(() {
      imagefiles = resultFiles;
    });
  }

  // MARK: Load Camera
  void _loadMediaFromCamera() {
    _showPicker(context);
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Image'),
                onTap: () {
                  _pickImage('image');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_camera_back),
                title: Text('Video'),
                onTap: () {
                  _pickImage("video");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(String type) async {
    final ImagePicker picker = ImagePicker();
    late XFile? pickedFile;
    if (type == "image") {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        _videoController = VideoPlayerController.file(File(pickedFile.path));
        await _videoController?.initialize();

        if (_videoController!.value.duration.inSeconds > 60) {
          showAppToast(context, "Video length has to be less than 1mins!");
          return;
        }
      }
    }

    setState(() {
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        imagefiles.add(image);
      } else {
        print('No image selected.');
      }
    });
  }

  // Future<String> uploadToDigitalOcean(File file) async {
  //   print("file.pathsdsdsdsdsdsdds");
  //   print(file.path);
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request('POST',
  //       Uri.parse('https://admin-workhouse-jade.vercel.app/api/upload'));
  //   request.body = json.encode({
  //     "fileName": "c0e2d701-8f76-4b5d-946d-77a040cefb8a2231632587207869156.jpg"
  //   });
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response1 = await request.send();
  //   print("log${response1}");

  //   log(await response1.stream.bytesToString());

  //   // Step 1: Request the pre-signed URL from your backend
  //   // final body = {"fileName": file.path.split('/').last};
  //   // print("BODYYYYYYYY${body}");
  //   // final response = await http.post(
  //   //   Uri.parse('https://admin-workhouse-jade.vercel.app/api/upload'),
  //   //   headers: {"Content-Type": "application/json"},
  //   //   body: body.toString(),
  //   // );

  //   print("RESPONSEEE ${response1.statusCode}");
  //   print("RESPONSEEE ${response1.request}");

  //   if (response1.statusCode >= 200 && response1.statusCode < 300) {
  //     final Map<String, dynamic> responseData = jsonDecode(request1.body);
  //     final url = responseData['url'];
  //     final fields = responseData['fields'];
  //     log('Pre-signed URL: $url');
  //     log('Upload fields: $fields');

  //     // Step 2: Create a Multipart request to upload the file
  //     final request = http.MultipartRequest('POST', Uri.parse(url));
  //     fields.forEach((key, value) {
  //       request.fields[key] = value;
  //     });

  //     // Add the file to the request
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'file',
  //       file.path,
  //       contentType: MediaType.parse(
  //           lookupMimeType(file.path) ?? 'application/octet-stream'),
  //     ));

  //     // Send the request
  //     final uploadResponse = await request.send();
  //     print('Uploadingggggggggg ${uploadResponse}');

  //     if (uploadResponse.statusCode == 204) {
  //       print('File uploaded successfully!');
  //       print('File path: ${file.path}');
  //       return file.path;
  //     } else {
  //       print(
  //           'Failed to upload file. Status code: ${uploadResponse.statusCode}');
  //       return "";
  //     }
  //   } else {
  //     print('Failed to get pre-signed URL: ${response.statusCode}');
  //     return "";
  //   }
  // }
  Future<String> uploadToDigitalOcean(File file) async {
    try {
      // Step 1: Request the pre-signed URL from your backend
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://admin-workhouse-jade.vercel.app/api/upload'),
      );

      // Sending file name in request body
      request.body = json.encode({
        "fileName":
            file.path.split('/').last, // get the file name from the file path
      });
      request.headers.addAll(headers);

      // Send the request and receive the pre-signed URL response
      http.StreamedResponse response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the JSON response
        final Map<String, dynamic> responseData =
            jsonDecode(await response.stream.bytesToString());
        final url = responseData['url'];
        final fields = Map<String, String>.from(responseData['fields']);
        log('Pre-signed URL: $url');
        log('Upload fields: $fields');

        // Step 2: Create a Multipart request to upload the file
        final uploadRequest = http.MultipartRequest('POST', Uri.parse(url));

        // Add the fields received from the pre-signed URL response
        fields.forEach((key, value) {
          uploadRequest.fields[key] = value;
        });

        // Add the file to the request
        uploadRequest.files.add(await http.MultipartFile.fromPath(
          'file', // field name in the form data
          file.path,
          contentType: MediaType.parse(
            lookupMimeType(file.path) ?? 'application/octet-stream',
          ),
        ));

        // Send the upload request
        final uploadResponse = await uploadRequest.send();
        if (uploadResponse.statusCode == 204) {
        
          return file.path;
        } else {
          print(
              'Failed to upload file. Status code: ${uploadResponse.statusCode}');
          return "";
        }
      } else {
        print('Failed to get pre-signed URL: ${response.statusCode}');
        return "";
      }
    } catch (e) {
      print('An error occurred: $e');
      return "";
    }
  }

  void createAnnouncement() async {
    _showProgressModal(context);
    prefs = await SharedPreferences.getInstance();

    List<Map<String, String>> data = [];
    for (File media in imagefiles) {
      // Upload each file to DigitalOcean Spaces
      await uploadToDigitalOcean(media);

      // Assuming you store URLs in `fields['key']`, add it to the data list
      final url =
          'https://nyc3.digitaloceanspaces.com/workhouse/uploads/${media.path.split('/').last}';
      if (lookupMimeType(media.path).toString().startsWith("image")) {
        // image
        data.add({
          "type": "image",
          "url": url,
        });
      } else {
        // video
        data.add({
          "type": "video",
          "url": url,
        });
      }
    }

    // Insert into your database
    try {
      await supabase.from("community_logs").insert({
        "sender": prefs.getString("userID"),
        "images": data,
        "community_id": prefs.getString("communityID"),
        "description": _description,
      });
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/community');
    } catch (e) {
      Navigator.of(context).pop();
      showAppToast(context, "Error occurred, please try again!");
    }
  }
// MARK: Continue
  // void createAnnouncement() async {
  //   // Navigator.of(context).pushNamed('/share-payment');

  //   _showProgressModal(context);
  //   prefs = await SharedPreferences.getInstance();
  //   supabase = Supabase.instance.client;
  //   String prefixURL =
  //       "https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/";

  //   List<dynamic> data = <dynamic>[];
  //   String uploadPath = "";
  //   for (File media in imagefiles) {
  //     uploadPath = await supabase.storage.from('community').upload(
  //           "${DateTime.now().microsecondsSinceEpoch}",
  //           media,
  //           fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
  //         );
  //     if (lookupMimeType(media.path).toString().startsWith("image")) {
  //       //image
  //       data.add({
  //         "type": "image",
  //         "url": prefixURL + uploadPath,
  //       });
  //     } else {
  //       //video
  //       data.add({
  //         "type": "video",
  //         "url": prefixURL + uploadPath,
  //       });
  //     }
  //   }
  //   try {
  //     await supabase.from("community_logs").insert({
  //       "sender": prefs.getString("userID"),
  //       "images": data,
  //       "community_id": prefs.getString("communityID"),
  //       "description": _description,
  //     });
  //     // ignore: use_build_context_synchronously
  //     Navigator.of(context).pop();
  //     // showAppToast(context, "Created successfully!");
  //     Navigator.pushNamed(context, '/community');
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.of(context).pop();
  //     showAppToast(context, "Error occured, please try again!");
  //   }
  // }

  // MARK: Custom Keyboard
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText,
          displayDoneButton: false,
          displayArrows: false,
          toolbarAlignment: MainAxisAlignment.spaceBetween,
          toolbarButtons: [
            //button 1
            (node) {
              return GestureDetector(
                onTap: () {
                  // print("gallery");
                  _loadMediaFromCamera();
                  // node.unfocus();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: Image.asset("assets/images/Camera.png"),
                ),
              );
            },
            //button 2
            (node) {
              return GestureDetector(
                onTap: () {
                  _loadMediaFromGallery();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  // margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: Image.asset("assets/images/Gallery.png"),
                ),
              );
            },
            //button
            (node) {
              return GestureDetector(
                child: Container(width: 1),
              );
            },
            //button
            (node) {
              return GestureDetector(
                child: Container(width: 1),
              );
            },
            //button
            (node) {
              return GestureDetector(
                child: Container(width: 1),
              );
            },
            //button 3
            (node) {
              return GestureDetector(
                onTap: () async {
                  // Navigator.of(context).pushNamed('/share-payment');
                  if (_description.isEmpty) {
                    showAppToast(context, "Please type description!");
                    return;
                  }
                  await makePayment();
                  // createAnnouncement();
                  // node.unfocus();
                },
                child: Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.21,
                      ),
                    ),
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  // MARK: Loading Progress Animation
  void _showProgressModal(BuildContext context) {
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

  //MARK: Payment

  Future<void> makePayment() async {
    if (_description.isEmpty) {
      showAppToast(context, "Please type description!");
      return;
    }
    try {
      // Create payment intent data
      paymentIntent = await createPaymentIntent('2', 'USD');
      // initialise the payment sheet setup
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Client secret key from payment data
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          // applePay: const PaymentSheetApplePay(
          //   // Currency and country code is accourding to India
          //   merchantCountryCode: "US",
          // ),
          // Merchant Name
          merchantDisplayName: 'Flutterwings',
          // return URl if you want to add
          // returnURL: 'flutterstripe://redirect',
        ),
      );
      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();
      // Display payment sheet
      displayPaymentSheet();
    } catch (e) {
      // print("exception $e");

      if (e is StripeConfigException) {
        // print("Stripe exception ${e.message}");
      } else {
        // print("exception $e");
      }
    }
  }

  displayPaymentSheet() async {
    try {
      // "Display payment sheet";
      await Stripe.instance.presentPaymentSheet();
      // Show when payment is done
      // Displaying snackbar for it
      createAnnouncement();
      // ignore: use_build_context_synchronously
      // showAppToast(context, "Paid successfully!");
      paymentIntent = null;
    } on StripeException catch (e) {
      // If any error comes during payment
      // so payment will be cancelled

      // ignore: use_build_context_synchronously
      // showAppToast(context, "Payment cancelled");
    } catch (e) {
      // ignore: use_build_context_synchronously
      showAppToast(context, "Error occured! Please try again.");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount)) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var secretKey =
          "sk_test_51PnWTm08Ulib0PHQqElIYnTFfpWUtayQVvNR0c69y1LX4E9pS4VKx9hWL0f5jWjXWpD0D5hgHUxJpD8dqlOKMrDf00DbAhp54q";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      // print('Payment Intent Body: ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      // print('Error charging user: ${err.toString()}');
    }
  }

  //MARK: Screen
  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              height: 34,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // print("gallery");
                          _loadMediaFromCamera();
                          // node.unfocus();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: SvgPicture.asset("assets/images/Camera.svg"),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          _loadMediaFromGallery();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          // margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
                          child: SvgPicture.asset("assets/images/Gallery.svg"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_description.isEmpty) {
                            // showAppToast(context, "Please type description!");
                            return;
                          }
                          await makePayment();
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _description.isEmpty
                                ? Color(0xFF898A8D)
                                : Colors.black,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            "Continue",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.21,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: GestureDetector(
                            child: SvgPicture.asset(
                              "assets/images/close.svg",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // MARK: screen-description
                      SizedBox(
                        height: 4,
                      ),
                      TextField(
                        maxLines: 10,
                        minLines: 3,
                        keyboardType: TextInputType.multiline,
                        // focusNode: _nodeText,
                        decoration: InputDecoration(
                          hintText: "Share your announcement.",
                          hintStyle: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Color(0xFFCBCBCB),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              height: 1.47,
                            ),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _description = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      //MARK: screen-media
                      Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: imagefiles.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                lookupMimeType(imagefiles[index].path)
                                        .toString()
                                        .startsWith("image")
                                    ? Container(
                                        height: 200,
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            imagefiles[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 200,
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: AppVideoPlayer(
                                            type: "file",
                                            source: imagefiles[index],
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  left: 12,
                                  top: 12,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        imagefiles.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF2D2D2D).withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: Icon(
                                        Ionicons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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
