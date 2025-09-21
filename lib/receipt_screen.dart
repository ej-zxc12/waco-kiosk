import 'package:flutter/material.dart';
import 'home_menu.dart';

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

  int _calculateTotal() {
    return cartItems.fold<int>(
      0,
      (sum, item) => sum + (item["price"] as int) * (item["qty"] as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        backgroundColor: const Color(0xFF6B4226),
        automaticallyImplyLeading: false, // ✅ No back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "🎉 Thank you for your order!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Order Number
            Text(
              "Order #$orderNumber",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final itemTotal =
                      (item["price"] as int) * (item["qty"] as int);

                  return ListTile(
                    leading: item["imagePath"] != null
                        ? Image.asset(item["imagePath"], width: 40, height: 40)
                        : const Icon(Icons.local_cafe, color: Colors.brown),
                    title: Text(
                      "${item["name"]} ${item["size"] != null ? "(${item["size"]})" : ""}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${item["qty"]} × ₱${item["price"]}"),
                    trailing: Text("₱$itemTotal"),
                  );
                },
              ),
            ),

            const Divider(thickness: 2),

            // ✅ Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                Text(
                  "₱$total",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ✅ Payment + Dining Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown, width: 2),
              ),
              child: Text(
                "Payment Method: $paymentMethod\nDining Location: $diningLocation",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Back to Home
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeMenu(
                      diningLocation: diningLocation, // ✅ pass it back
                    ),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home),
              label: const Text("Back to Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4226),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
