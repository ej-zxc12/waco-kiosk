import 'package:flutter/material.dart';
import 'helpers.dart'; // for showCancelConfirmation
import 'waffle_details.dart'; // ✅ import details screen

class WaffleScreen extends StatelessWidget {
  const WaffleScreen({super.key});

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
                    "WAFFLE",
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
                  buildProductItem(context, "Mango", "assets/images/Waf mango.png", 79),
                  buildProductItem(context, "Choco Oreo", "assets/images/Waf choco oreo.png", 79),
                  buildProductItem(context, "Choco Banana", "assets/images/Waf chocobanana.png", 79),
                  buildProductItem(context, "Oreo", "assets/images/Waffle Oreo.png", 79),
                  buildProductItem(context, "Strawberry", "assets/images/Waf strawberry.png", 79),
                  buildProductItem(context, "Blueberry", "assets/images/Waf blueberry.png", 79),
                  buildProductItem(
                    context,
                    "Plain Waffle",
                    "assets/images/plainwaffle.png",
                    59,
                    withCaramel: true, // ✅ caramel option only for plain
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

  /// PRODUCT ITEM (image box + name below + navigation)
  Widget buildProductItem(BuildContext context, String title, String imagePath, int basePrice, {bool withCaramel = false}) {
    return Column(
      children: [
        Expanded(
          child: AnimatedScaleButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WaffleDetailsScreen(
                    title: title,
                    imagePath: imagePath,
                    basePrice: basePrice,
                    withCaramel: withCaramel,
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
