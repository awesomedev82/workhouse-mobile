import 'dart:async';
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/components/app_input.dart';
import 'package:workhouse/components/app_video_player.dart';
import 'package:workhouse/utils/constant.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:permission_handler/permission_handler.dart';

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
  String _description = "";

  List<Asset> images = <Asset>[];
  List<File> imagefiles = <File>[];

  Future<void> _loadAssets() async {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    List<Asset> resultList = <Asset>[];
    String error = 'No Error Dectected';

    const AlbumSetting albumSetting = AlbumSetting(
      fetchResults: {
        PHFetchResult(
          type: PHAssetCollectionType.smartAlbum,
          subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary,
        ),
        PHFetchResult(
          type: PHAssetCollectionType.smartAlbum,
          subtype: PHAssetCollectionSubtype.smartAlbumFavorites,
        ),
        PHFetchResult(
          type: PHAssetCollectionType.album,
          subtype: PHAssetCollectionSubtype.albumRegular,
        ),
        PHFetchResult(
          type: PHAssetCollectionType.smartAlbum,
          subtype: PHAssetCollectionSubtype.smartAlbumSelfPortraits,
        ),
        PHFetchResult(
          type: PHAssetCollectionType.smartAlbum,
          subtype: PHAssetCollectionSubtype.smartAlbumPanoramas,
        ),
        PHFetchResult(
          type: PHAssetCollectionType.smartAlbum,
          subtype: PHAssetCollectionSubtype.smartAlbumVideos,
        ),
      },
    );
    const SelectionSetting selectionSetting = SelectionSetting(
      min: 0,
      max: 20,
      unselectOnReachingMax: true,
    );
    const DismissSetting dismissSetting = DismissSetting(
      enabled: true,
      allowSwipe: true,
    );
    final ThemeSetting themeSetting = ThemeSetting(
      backgroundColor: colorScheme.background,
      selectionFillColor: colorScheme.primary,
      selectionStrokeColor: colorScheme.onPrimary,
      previewSubtitleAttributes: const TitleAttribute(fontSize: 12.0),
      previewTitleAttributes: TitleAttribute(
        foregroundColor: colorScheme.primary,
      ),
      albumTitleAttributes: TitleAttribute(
        foregroundColor: colorScheme.primary,
      ),
    );
    const ListSetting listSetting = ListSetting(
      spacing: 5.0,
      cellsPerRow: 4,
    );
    const AssetsSetting assetsSetting = AssetsSetting(
      // Set to allow pick videos.
      supportedMediaTypes: {MediaTypes.video, MediaTypes.image},
    );
    final CupertinoSettings iosSettings = CupertinoSettings(
      fetch: const FetchSetting(album: albumSetting, assets: assetsSetting),
      theme: themeSetting,
      selection: selectionSetting,
      dismiss: dismissSetting,
      list: listSetting,
    );

    try {
      resultList = await MultiImagePicker.pickImages(
        // selectedAssets: images,
        iosOptions: IOSOptions(
          doneButton:
              UIBarButtonItem(title: 'Confirm', tintColor: colorScheme.primary),
          cancelButton:
              UIBarButtonItem(title: 'Cancel', tintColor: colorScheme.primary),
          albumButtonColor: colorScheme.primary,
          settings: iosSettings,
        ),
        androidOptions: AndroidOptions(
          actionBarColor: colorScheme.surface,
          actionBarTitleColor: colorScheme.onSurface,
          statusBarColor: colorScheme.surface,
          actionBarTitle: "Select Photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: colorScheme.primary,
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      assetsToFiles();
    });
  }

  void assetsToFiles() async {
    List<File> tempFiles = [];
    for (Asset asset in images) {
      File file = await assetToFile(asset);
      tempFiles.add(file);
    }
    setState(() {
      imagefiles = tempFiles;
    });
  }

  Future<File> assetToFile(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${asset.name}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void createAnnouncement() async {
    // Navigator.of(context).pushNamed('/share-payment');
    _showCustomModal(context);
    prefs = await SharedPreferences.getInstance();
    supabase = Supabase.instance.client;
    String prefixURL =
        "https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/";

    if (kDebugMode) {
      print(prefs.getString("communityID"));
      print(prefs.getString("userID"));
      print(_description);
    }
    List<dynamic> data = <dynamic>[];
    String uploadPath = "";
    for (File media in imagefiles) {
      uploadPath = await supabase.storage.from('community').upload(
            "${DateTime.now().microsecondsSinceEpoch}",
            media,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      if (lookupMimeType(media.path).toString().startsWith("image")) {
        //image
        data.add({
          "type": "image",
          "url": prefixURL + uploadPath,
        });
      } else {
        //video
        data.add({
          "type": "video",
          "url": prefixURL + uploadPath,
        });
      }
    }
    try {
      await supabase.from("community_logs").insert({
        "sender": prefs.getString("userID"),
        "images": data,
        "community_id": prefs.getString("communityID"),
        "description": _description,
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        title: Text(
          "Error occured, please try again!",
          style: TextStyle(color: Colors.red[600]),
        ),
        // ignore: use_build_context_synchronously
      ).show(context);
    }
  }

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
                onTap: () => node.unfocus(),
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
                  // print("gallery");
                  _loadAssets();
                  // node.unfocus();
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
                onTap: () {
                  createAnnouncement();
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
    return KeyboardActions(
      config: _buildConfig(context),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  maxLines: 10,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _nodeText,
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
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      imagefiles[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 200,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AppVideoPlayer(
                                        sourceFile: imagefiles[index]),
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
                                  color: Color(0xFF2D2D2D).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Icon(Ionicons.close,
                                    color: Colors.white, size: 24),
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
    );
  }
}
