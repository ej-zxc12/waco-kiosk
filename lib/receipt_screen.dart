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
          children: [
            const SizedBox(height: 20),

            // ✅ Logo
            Image.asset(
              "assets/images/wacologo.png",
              height: 80,
            ),

            const SizedBox(height: 10),

            const Text(
              "The WaCo - San Jose",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Order Info
            Text(
              "Order Receipt",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Order No: #$orderNumber",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Order Items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        item["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B4226),
                        ),
                      ),
                      subtitle: Text("Qty: ${item["qty"]}"),
                      trailing: Text(
                        "₱${item["price"] * item["qty"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ✅ Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 2,
              color: const Color(0xFF6B4226),
            ),

            // ✅ Total
            Text(
              "Total: ₱$total",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226),
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Payment & Dining Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Payment Method: $paymentMethod",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Dining: $diningLocation",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Back Button
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
                cartItems.clear();
                cartItemCount.value = 0;

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 3), () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    });

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        "✅ Order Successful",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B4226),
                        ),
                      ),
                      content: const Text(
                        "Thank you for your order!\nPlease wait while we prepare it.",
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
