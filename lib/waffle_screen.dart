import 'package:flutter/material.dart';
import 'helpers.dart';
import 'waffle_details.dart'; // ✅ use WaffleDetailsScreen

class WaffleScreen extends StatelessWidget {
  final String diningLocation;

  const WaffleScreen({super.key, required this.diningLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
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
                  Column(
                    children: [
                      const Text(
                        "WAFFLES",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Dining: $diningLocation",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            /// WAFFLES GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                padding: const EdgeInsets.all(24),
                children: [
                  buildProductItem(
                    context,
                    name: "Plain Waffle",
                    imagePath: "assets/images/plainwaffle.png",
                    price: 59,
                  ),
                  buildProductItem(
                    context,
                    name: "Oreo Waffle",
                    imagePath: "assets/images/Waffle Oreo.png",
                    price: 79,
                  ),
                  buildProductItem(
                    context,
                    name: "Chocolate Oreo Waffle",
                    imagePath: "assets/images/Waf choco oreo.png",
                    price: 79,
                  ),
                  buildProductItem(
                    context,
                    name: "Mango Waffle",
                    imagePath: "assets/images/Waf mango.png",
                    price: 79,
                  ),
                  buildProductItem(
                    context,
                    name: "Strawberry Waffle",
                    imagePath: "assets/images/Waf strawberry.png",
                    price: 79,
                  ),
                  buildProductItem(
                    context,
                    name: "Choco Banana Waffle",
                    imagePath: "assets/images/Waf chocobanana.png",
                    price: 79,
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
                  onPressed: () => showCancelConfirmation(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 PRODUCT ITEM WIDGET
  Widget buildProductItem(
    BuildContext context, {
    required String name,
    required String imagePath,
    required int price,
  }) {
    return Column(
      children: [
        Expanded(
          child: AnimatedScaleButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WaffleDetailsScreen(
                    name: name, // ✅ fixed
                    price: price, // ✅ fixed
                    imagePath: imagePath, // ✅ fixed
                    diningLocation: diningLocation, // ✅ still required
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(3, 4),
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
          name,
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
