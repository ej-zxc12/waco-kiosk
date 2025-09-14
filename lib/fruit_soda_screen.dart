import 'package:flutter/material.dart';
import 'helpers.dart'; // ✅ Reuse AnimatedButton, AnimatedScaleButton, showCancelConfirmation
import 'product_details.dart'; // ✅ for navigating to details screen

class FruitSodaScreen extends StatelessWidget {
  const FruitSodaScreen({super.key});

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
                    "FRUIT SODA",
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
                  buildProductItem(context, "Strawberry", "assets/images/FruitSOda-removebg-preview.png"),
                  buildProductItem(context, "Blue Lemonade", "assets/images/FS blue lemonade.png"),
                  buildProductItem(context, "Blueberry", "assets/images/FS blue berry.png"),
                  buildProductItem(context, "Apple Green", "assets/images/FS apple green.png"),
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

  /// PRODUCT ITEM (navigates to ProductDetailsScreen with Fruit Soda prices)
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
                      {"label": "16oz", "price": 59},
                      {"label": "22oz", "price": 69},
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
