import 'package:flutter/material.dart';
import 'helpers.dart'; // ✅ Reuse AnimatedButton, AnimatedScaleButton, showCancelConfirmation
import 'product_details.dart'; // ✅ reuse MilkTea ProductDetailsScreen

class FruitYogurtScreen extends StatelessWidget {
  const FruitYogurtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Beige background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                    "FRUIT YOGURT",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// PRODUCT GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                padding: const EdgeInsets.all(24),
                children: [
                  buildProductItem(context, "Strawberry", "assets/images/FY strawberry.png"),
                  buildProductItem(context, "Blueberry", "assets/images/FY blueberry.png"),
                  buildProductItem(context, "Lychee", "assets/images/FY lychee.png"),
                  buildProductItem(context, "Four Seasons", "assets/images/FY four.png"),
                  buildProductItem(context, "Blue Lemonade", "assets/images/FY bluelemo.png"),
                  buildProductItem(context, "Apple Green", "assets/Fruit_yogurt-removebg-preview.png"),
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
                    showCancelConfirmation(context); // ✅ uses helper
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// PRODUCT ITEM (navigates to ProductDetailsScreen)
  Widget buildProductItem(BuildContext context, String title, String imagePath) {
    return Column(
      children: [
        Expanded(
          child: AnimatedScaleButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsScreen(
                    productName: title,
                    imagePath: imagePath,
                    options: [
                      {"label": "16oz", "price": 49},
                      {"label": "22oz", "price": 59},
                    ],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(3, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
