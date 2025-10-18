import 'package:flutter/material.dart';
import 'receipt_screen.dart';

class ReceiptOptionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String paymentMethod;
  final String diningLocation;

  const ReceiptOptionScreen({
    super.key,
    required this.cartItems,
    required this.paymentMethod,
    required this.diningLocation,
  });

  void _goToReceipt(BuildContext context, String receiptOption) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          cartItems: cartItems,
          paymentMethod: paymentMethod,
          diningLocation: diningLocation,
          orderNumber: DateTime.now().millisecondsSinceEpoch % 10000,
          receiptOption: receiptOption, // ✅ Pass Yes or N/A
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Do you want a receipt?",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // Yes / No Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ YES BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4226),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => _goToReceipt(context, "Yes"),
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 40),

                // ❌ NO BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => _goToReceipt(context, "N/A"),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
