import 'package:flutter/material.dart';
import 'home_menu.dart'; // ✅ import the new HomeMenu file

class DiningLocationScreen extends StatelessWidget {
  const DiningLocationScreen({super.key});

  void _selectDining(BuildContext context, String location) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeMenu(
          diningLocation: location, // ✅ pass dining location to HomeMenu
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // soft beige
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Dining Location",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B4226),
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🍽 Dine-In Option
                  GestureDetector(
                    onTap: () => _selectDining(context, "Dine-In"),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/WaCo Dine In Image.png",
                          width: 150,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Dine-In",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B4226),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // 🥡 Takeout Option
                  GestureDetector(
                    onTap: () => _selectDining(context, "Takeout"),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/WaCo Take out Image.png",
                          width: 150,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Takeout",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B4226),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
