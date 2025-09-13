import 'package:flutter/material.dart';
import 'dining_location.dart'; // Dining screen

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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// ✅ Splash Screen (first page)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Go to Dining Location screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DiningLocationScreen(),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF8B5E3C), // Brown background
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/images/wacologo.png", // Make sure this file exists
                width: 180,
              ),
              const SizedBox(height: 40),
              const Text(
                "TOUCH TO START",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
