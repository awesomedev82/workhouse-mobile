import 'package:flutter/foundation.dart';

class AnnouncementProvider with ChangeNotifier {
  List<dynamic> _announcements = [];
  List<dynamic> _myAnnouncements = [];

  List<dynamic> get announcements => _announcements;
  List<dynamic> get myAnnouncements => _myAnnouncements;

  void setAnnouncements(List<dynamic> announcements) {
    _announcements = announcements;
    notifyListeners();
  }

  void setMyAnnouncements(List<dynamic> myAnnouncements) {
    _myAnnouncements = myAnnouncements;
    notifyListeners();
  }
}
