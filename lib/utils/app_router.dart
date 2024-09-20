import 'package:flutter/material.dart';
import 'package:workhouse/screens/core_screens/account/account_screen.dart';
import 'package:workhouse/screens/core_screens/account/edit_profile_screen.dart';
import 'package:workhouse/screens/core_screens/directory/directory_screen.dart';
import 'package:workhouse/screens/core_screens/directory/selected_member_screen.dart';
import 'package:workhouse/screens/create_announcement/community_screen.dart';
import 'package:workhouse/screens/create_announcement/selected_announcement_screen.dart';
import 'package:workhouse/screens/create_announcement/share_first_screen.dart';
import 'package:workhouse/screens/create_announcement/share_third_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/launch_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/launch_total.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_first_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_fouth_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_second_screen.dart';
import 'package:workhouse/screens/launch+walkthrough/walk_third_screen.dart';
import 'package:workhouse/screens/signin+create_account/check_email.dart';
import 'package:workhouse/screens/signin+create_account/code_verification_screen.dart';
import 'package:workhouse/screens/signin+create_account/create_account_screen.dart';
import 'package:workhouse/screens/signin+create_account/directory/add_directory.dart';
import 'package:workhouse/screens/signin+create_account/sign_in_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LaunchTotal());
      case '/walk-first':
        return MaterialPageRoute(builder: (_) => WalkFirstScreen());
      case '/walk-second':
        return MaterialPageRoute(builder: (_) => WalkSecondScreen());
      case '/walk-third':
        return MaterialPageRoute(builder: (_) => WalkThirdScreen());
      case '/walk-fouth':
        return MaterialPageRoute(builder: (_) => WalkFouthScreen());
      case '/sign-in':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/check-email':
        return MaterialPageRoute(builder: (_) => CheckEmail());
      case '/create-account':
        return MaterialPageRoute(builder: (_) => CreateAccountScreen());
      case '/code-verification':
        return MaterialPageRoute(builder: (_) => CodeVerificationScreen());
      case '/add-directory':
        return MaterialPageRoute(builder: (_) => AddDirectory());
      case '/community':
        return MaterialPageRoute(builder: (_) => CommunityScreen());
      case '/share-announcement':
        return MaterialPageRoute(builder: (_) => ShareFirstScreen());
      case '/share-payment':
        return MaterialPageRoute(builder: (_) => ShareThirdScreen());
      case '/account':
        return MaterialPageRoute(builder: (_) => AccountScreen());
      case '/edit-profile':
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case '/directory':
        return MaterialPageRoute(builder: (_) => DirectoryScreen());
      case '/selected-member':
        return MaterialPageRoute(builder: (_) => SelectedMemberScreen());
      case '/selected-announcement':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SelectedAnnouncementScreen(data: args['data']),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          ),
        );
    }
  }
}
