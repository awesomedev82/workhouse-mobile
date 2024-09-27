import 'package:flutter/foundation.dart';

class AnnouncementProvider with ChangeNotifier {
  List<dynamic> _announcements = [];
  List<dynamic> _myAnnouncements = [];
  List<dynamic> _otherAnnouncements = [];

  List<dynamic> get announcements => _announcements;
  List<dynamic> get myAnnouncements => _myAnnouncements;
  List<dynamic> get otherAnnouncements => _otherAnnouncements;

  void setAnnouncements(List<dynamic> announcements) {
    _announcements = announcements;
    notifyListeners();
  }

  void setMyAnnouncements(List<dynamic> myAnnouncements) {
    _myAnnouncements = myAnnouncements;
    notifyListeners();
  }

  void setOtherAnnouncements(List<dynamic> otherAnnouncements) {
    _otherAnnouncements = otherAnnouncements;
    notifyListeners();
  }
}
