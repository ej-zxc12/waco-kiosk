import 'package:flutter/material.dart';
import 'checkout_screen.dart'; // ✅ replace with your actual checkout import
import 'home_menu.dart'; // ✅ if cancel should bring back home

class PaymentMethodScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const PaymentMethodScreen({super.key, required this.cartItems});

  void _goToCheckout(BuildContext context, String method) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          cartItems: cartItems,
          // ✅ you can pass method if checkout needs it
          // paymentMethod: method, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // soft beige like DiningLocation
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226),
              ),
            ),
            const SizedBox(height: 40),

            // Payment options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GCash
                GestureDetector(
                  onTap: () => _goToCheckout(context, "Cashless"),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/Cashless payment.png", // ✅ change to your GCash asset
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "GCash",
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

                // Cash
                GestureDetector(
                  onTap: () => _goToCheckout(context, "Pay at the Counter"),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/counter.png", // ✅ change to your Cash asset
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Cash",
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

            const SizedBox(height: 60),

            // Cancel Order button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 117, 116, 119), // ✅ kiosk-like red
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeMenu(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "Cancel Order",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
