import 'package:flutter/material.dart';
import 'helpers.dart'; // for showCancelConfirmation, AnimatedButton, AnimatedScaleButton
import 'product_details.dart'; // ✅ reuse ProductDetailsScreen

class IcedCoffeeScreen extends StatelessWidget {
  final String diningLocation; // ✅ keep dining location context

  const IcedCoffeeScreen({super.key, required this.diningLocation});

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
                    "ICED COFFEE",
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
                  buildProductItem(context, "Hazelnut", "assets/images/IC hazelnut.png"),
                  buildProductItem(context, "Iced Americano", "assets/images/Iced Americano.png"),
                  buildProductItem(context, "French Vanilla", "assets/images/IC french vanilla.png"),
                  buildProductItem(context, "Spanish Latte", "assets/images/IC spanish latte.png"),
                  buildProductItem(context, "Salted Caramel", "assets/images/Iced-Coffee_img-removebg-preview.png"),
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
                      {"label": "12oz", "price": 49},
                      {"label": "16oz", "price": 59},
                    ],
                    diningLocation: diningLocation, // ✅ pass dining location
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
