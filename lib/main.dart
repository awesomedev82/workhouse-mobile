import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  // await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://lgkqpwmgwwexlxfnvoyp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxna3Fwd21nd3dleGx4Zm52b3lwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2NTUwNTAsImV4cCI6MjAzOTIzMTA1MH0.qiFcXbioNaggHs194TZJJS48hpbSvVssnhcnrIi7jbw',
  );
  Stripe.publishableKey =
      'pk_test_51PnWTm08Ulib0PHQhD8OVgpaseIx9UWVoFDR4GjK3GlNlARFGsEl42nve2vnRVAUJdVWfmfeu5L5ljbt54aFqwR000t7Ken8nA';
  await Stripe.instance.applySettings();
  // initNotifications();
  runApp(MyApp());
}

void initNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(
      message.notification?.title,
      message.notification?.body,
    );
  });
}

Future<void> showNotification(String? title, String? body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    title ?? 'No Title',
    body ?? 'No Body',
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
