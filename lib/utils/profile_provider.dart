import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "";
  String _avatar = "";
  List<dynamic> _myAnnouncement = <dynamic>[];

  // Getters
  String get name => _name;
  String get avatar => _avatar;
  List<dynamic> get myAnnouncement => _myAnnouncement;

  // Setter for name
  set name(String newName) {
    if (newName.isNotEmpty) {
      _name = newName;
      notifyListeners();
    }
  }

  set avatar(String newAvatar) {
    if (newAvatar.isNotEmpty) {
      _avatar = newAvatar;
      notifyListeners();
    }
  }

  set myAnnouncement(List<dynamic> newAnnouncement) {
    if (newAnnouncement.isNotEmpty) {
      _myAnnouncement = newAnnouncement;
      notifyListeners();
    }
  }
}
