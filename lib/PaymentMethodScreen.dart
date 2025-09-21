import 'package:flutter/material.dart';
import 'home_menu.dart'; // ✅ if cancel should bring back home
import 'receipt_screen.dart'; // ✅ show receipt after selecting payment

class PaymentMethodScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String diningLocation; // ✅ pass from DiningLocationScreen

  const PaymentMethodScreen({
    super.key,
    required this.cartItems,
    required this.diningLocation,
  });

  void _goToReceipt(BuildContext context, String method) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          cartItems: cartItems,
          paymentMethod: method,
          diningLocation: diningLocation,
          orderNumber: DateTime.now().millisecondsSinceEpoch % 10000, // simple order no.
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // soft beige
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

            // Payment options styled like DiningLocationScreen
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pay at Counter
                GestureDetector(
                  onTap: () => _goToReceipt(context, "Pay at the Counter"),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/counter.png",
                        width: 160,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Pay at the Counter",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B4226),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 50),

                // Cashless
                GestureDetector(
                  onTap: () => _goToReceipt(context, "Cashless"),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/Cashless payment.png",
                        width: 160,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Cashless",
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

            const SizedBox(height: 70),

            // Cancel Order button (kiosk style)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700, // ✅ kiosk-like red
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeMenu(
                      diningLocation: diningLocation, // ✅ keep dining location
                    ),
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
