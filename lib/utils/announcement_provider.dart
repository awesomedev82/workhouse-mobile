import 'package:flutter/foundation.dart';

class AnnouncementProvider with ChangeNotifier {
  List<dynamic> _announcements = [];

  List<dynamic> get announcements => _announcements;

  void setAnnouncements(List<dynamic> announcements) {
    _announcements = announcements;
    notifyListeners();
  }
}