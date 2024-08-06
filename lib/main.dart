import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workhouse/screens/launch+walkthrough/launch_screen.dart';
import 'package:workhouse/screens/signin+create_account/sign_in_screen.dart';

/**
 * MARK: App Entry point
 */

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workhouse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF000000)),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Workhouse',
      ),
    );
  }
}

/**
 * MARK: Default Template Class Widget
 */

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaunchScreen(), // Call launch screen
    );
  }
}
