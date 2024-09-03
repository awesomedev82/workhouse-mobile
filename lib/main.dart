import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workhouse/utils/app_router.dart';

/**
 * MARK: App Entry point
 */

Future<void> main() async {
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


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workhouse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF000000)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
