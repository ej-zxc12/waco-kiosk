import 'package:flutter/material.dart';
import 'idle_wrapper.dart';
import 'splash_screen.dart';
import 'nav.dart';

void main() {
  runApp(const KioskApp());
}

class KioskApp extends StatelessWidget {
  const KioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "The WaCo Kiosk",
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Roboto', // Optional: consistent font
      ),
      navigatorKey: Nav.navKey,
      builder: (context, child) => IdleWrapper(
        idleDuration: const Duration(seconds: 60),
        child: child ?? const SizedBox.shrink(),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
