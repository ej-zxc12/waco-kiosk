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
        body: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final shortest = w < h ? w : h;

            // Scale values based on available space with sensible caps.
            final logoWidth = (shortest * 0.30).clamp(120.0, 320.0).toDouble();
            final gap = (shortest * 0.06).clamp(16.0, 64.0).toDouble();
            final fontSize = (shortest * 0.035).clamp(16.0, 32.0).toDouble();

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/wacologo.png",
                    width: logoWidth,
                  ),
                  SizedBox(height: gap),
                  Text(
                    "TOUCH TO START",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

