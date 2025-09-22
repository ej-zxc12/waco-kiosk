import 'package:flutter/material.dart';
import 'dining_location.dart'; // ✅ go back to dining location instead
import 'home_menu.dart' show cartItemCount; // ✅ import only the global counter

class ReceiptScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String paymentMethod;
  final String diningLocation;
  final int orderNumber;

  const ReceiptScreen({
    super.key,
    required this.cartItems,
    required this.paymentMethod,
    required this.diningLocation,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    int total = cartItems.fold<int>(
      0,
      (sum, item) => sum + (item["price"] as int) * (item["qty"] as int),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Receipt",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Order No: #$orderNumber",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item["name"]),
                    subtitle: Text("Qty: ${item["qty"]}"),
                    trailing: Text("₱${item["price"] * item["qty"]}"),
                  );
                },
              ),
            ),

            Text(
              "Total: ₱$total",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Payment: $paymentMethod\nDining: $diningLocation",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4226),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () async {
                // ✅ Clear cart before going back
                cartItems.clear();
                cartItemCount.value = 0;

                // ✅ Show thank you popup with auto close
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    // Auto-close after 3 seconds
                    Future.delayed(const Duration(seconds: 3), () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context); // close dialog
                      }
                    });

                    return AlertDialog(
                      title: const Text("✅ Order Successful"),
                      content: const Text(
                        "Thank you for your order!\nPlease wait while we prepare it.",
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4226),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ).then((_) {
                  // ✅ After dialog closes (auto or manual), go back
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiningLocationScreen(),
                    ),
                    (route) => false,
                  );
                });
              },
              child: const Text(
                "Back to Home",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
