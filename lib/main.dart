import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/firebase_options.dart';
import 'package:workhouse/utils/announcement_provider.dart';
import 'package:workhouse/utils/app_router.dart';
import 'package:workhouse/utils/profile_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/standalone.dart' as tz;

/**
 * MARK: App Entry point
 */

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/New_York'));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://lgkqpwmgwwexlxfnvoyp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxna3Fwd21nd3dleGx4Zm52b3lwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2NTUwNTAsImV4cCI6MjAzOTIzMTA1MH0.qiFcXbioNaggHs194TZJJS48hpbSvVssnhcnrIi7jbw',
  );
  Stripe.publishableKey =
      'pk_test_51PnWTm08Ulib0PHQhD8OVgpaseIx9UWVoFDR4GjK3GlNlARFGsEl42nve2vnRVAUJdVWfmfeu5L5ljbt54aFqwR000t7Ken8nA';
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white, // Set to white
        // systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness:
            Brightness.dark, // Set the icon brightness to dark
        systemNavigationBarIconBrightness:
            Brightness.dark, // Adjust navigation bar icons // Adjust icons
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnnouncementProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Workhouse',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF000000)),
          useMaterial3: true,
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
