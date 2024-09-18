import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "";
  String _avatar = "";
  String _phonenumber = "";
  String _businessName = "";
  String _bio = "";
  String _website = "";
  String _publicName = "";
  String _industry = "Architecture";

  // Getters
  String get name => _name;
  String get avatar => _avatar;
  String get phonenumber => _phonenumber;
  String get businessName => _businessName;
  String get bio => _bio;
  String get website => _website;
  String get publicName => _publicName;
  String get industry => _industry;

  // Setter for name
  set name(String val) {
    if (val.isNotEmpty) {
      _name = val;
      notifyListeners();
    }
  }

  set avatar(String val) {
    if (val.isNotEmpty) {
      _avatar = val;
      notifyListeners();
    }
  }

  set phonenumber(String val) {
    if (val.isNotEmpty) {
      _phonenumber = val;
      notifyListeners();
    }
  }

  set businessName(String val) {
    if (val.isNotEmpty) {
      _businessName = val;
      notifyListeners();
    }
  }

  set bio(String val) {
    if (val.isNotEmpty) {
      _bio = val;
      notifyListeners();
    }
  }

  set publicName(String val) {
    if (val.isNotEmpty) {
      _publicName = val;
      notifyListeners();
    }
  }

  set website(String val) {
    if (val.isNotEmpty) {
      _website = val;
      notifyListeners();
    }
  }

  set industry(String val) {
    if (val.isNotEmpty) {
      _industry = val;
      notifyListeners();
    }
  }
}
