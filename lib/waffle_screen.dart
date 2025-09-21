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
                        Text("Back",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Text("WAFFLES",
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5)),
                      const SizedBox(height: 2),
                      Text("Dining: $diningLocation",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.brown)),
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
                    title: "Plain Waffle",
                    imagePath: "assets/images/Waffle Plain.png",
                    basePrice: 35,
                    withCaramel: true, // ✅ only Plain Waffle has caramel option
                  ),
                  buildProductItem(
                    context,
                    title: "Oreo Waffle",
                    imagePath: "assets/images/Waffle Oreo.png",
                    basePrice: 39,
                  ),
                  buildProductItem(
                    context,
                    title: "Chocolate Waffle",
                    imagePath: "assets/images/Waffle Choco.png",
                    basePrice: 39,
                  ),
                  buildProductItem(
                    context,
                    title: "Matcha Waffle",
                    imagePath: "assets/images/Waffle Matcha.png",
                    basePrice: 39,
                  ),
                  buildProductItem(
                    context,
                    title: "Strawberry Waffle",
                    imagePath: "assets/images/Waffle Strawberry.png",
                    basePrice: 39,
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
    required String title,
    required String imagePath,
    required int basePrice,
    bool withCaramel = false,
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
                    title: title,
                    imagePath: imagePath,
                    basePrice: basePrice,
                    withCaramel: withCaramel,
                    diningLocation: diningLocation, // ✅ pass location
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
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}
