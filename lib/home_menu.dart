import 'package:flutter/material.dart';
import 'dining_location.dart'; // For back navigation
import 'Milktea_screen.dart';
import 'iced_coffee_screen.dart';
import 'fruit_soda_screen.dart';
import 'fruit_yogurt_screen.dart';
import 'waffle_screen.dart';
import 'cart_screen.dart';
import 'helpers.dart';

/// 🔹 Global cart counter (can be updated anywhere in the app)
ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

/// 🔹 Global cart items list (accessible anywhere)
List<Map<String, dynamic>> cartItems = [];

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Beige background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER (Menu + Back Button + Cart Button with badge)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiningLocationScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.black, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "MENU",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),

                  /// 🔹 Cart Button with Badge
                  ValueListenableBuilder<int>(
                    valueListenable: cartItemCount,
                    builder: (context, count, _) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CartScreen(cartItems: cartItems), // ✅ FIXED
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.brown, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: const Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.brown,
                                size: 28,
                              ),
                            ),
                          ),

                          /// 🔹 Badge Counter
                          if (count > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "$count",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// MENU ITEMS
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                padding: const EdgeInsets.all(24),
                children: [
                  buildMenuItem(
                    context,
                    "ICED COFFEE",
                    "assets/images/Iced-Coffee_img-removebg-preview.png",
                  ),
                  buildMenuItem(
                    context,
                    "MILKTEA",
                    "assets/images/Milktea-removebg-preview.png",
                  ),
                  buildMenuItem(
                    context,
                    "FRUIT SODA",
                    "assets/images/FruitSOda-removebg-preview.png",
                  ),
                  buildMenuItem(
                    context,
                    "FRUIT YOGURT",
                    "assets/images/Fruit_yogurt-removebg-preview.png",
                  ),
                  buildMenuItem(
                    context,
                    "WAFFLE",
                    "assets/images/Waffle Oreo.png",
                  ),
                ],
              ),
            ),

            /// CANCEL ORDER BUTTON
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: AnimatedButton(
                  label: "Cancel Order",
                  onPressed: () {
                    showCancelConfirmation(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Menu Item Widget with Tap Animation + Navigation
  Widget buildMenuItem(BuildContext context, String title, String imagePath) {
    return AnimatedScaleButton(
      onTap: () {
        if (title == "MILKTEA") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MilkteaScreen()),
          );
        } else if (title == "ICED COFFEE") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IcedCoffeeScreen()),
          );
        } else if (title == "FRUIT SODA") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FruitSodaScreen()),
          );
        } else if (title == "FRUIT YOGURT") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FruitYogurtScreen()),
          );
        } else if (title == "WAFFLE") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WaffleScreen()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.brown, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(3, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4226),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
