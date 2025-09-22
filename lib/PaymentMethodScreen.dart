import 'package:flutter/material.dart';
import 'home_menu.dart'; 
import 'receipt_screen.dart';
import 'dining_location.dart'; // ✅ import dining location screen

class PaymentMethodScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String diningLocation;

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
          orderNumber: DateTime.now().millisecondsSinceEpoch % 10000,
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5E6D3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Cancel Order?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4226),
            ),
          ),
          content: const Text(
            "Are you sure you want to cancel your order? "
            "All items in your cart will be removed.",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog only
              },
              child: const Text(
                "No",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            TextButton(
              onPressed: () {
                // ✅ clear cart
                cartItems.clear();
                cartItemCount.value = 0;

                Navigator.of(context).pop(); // close dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DiningLocationScreen(), // ✅ back to dining location
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "Yes, Cancel",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
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

            // Cancel Order button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
              ),
              onPressed: () => _confirmCancel(context),
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
