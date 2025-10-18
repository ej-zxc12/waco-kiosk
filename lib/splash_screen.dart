import 'package:flutter/material.dart';
import 'dining_location.dart';
import 'nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Nav.idleEnabled.value = false; // disable idle while on splash
  }

  @override
  void dispose() {
    Nav.idleEnabled.value = true; // re-enable idle for the rest of the app
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DiningLocationScreen(),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF8B5E3C),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/wacologo.png",
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
