import 'package:flutter/material.dart';
import 'home_menu.dart' show cartItemCount;
import 'responsive_layout.dart';
import 'main.dart'; // ✅ Added import to access SplashScreen

class ReceiptScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String paymentMethod;
  final String diningLocation;
  final String receiptOption;
  final int orderNumber;

  const ReceiptScreen({
    super.key,
    required this.cartItems,
    required this.paymentMethod,
    required this.diningLocation,
    required this.orderNumber,
    this.receiptOption = "Yes", // ✅ Default
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _ReceiptContent(
        cartItems: cartItems,
        paymentMethod: paymentMethod,
        diningLocation: diningLocation,
        orderNumber: orderNumber,
        receiptOption: receiptOption,
        fontScale: 0.9,
        paddingScale: 0.8,
      ),
      tablet: _ReceiptContent(
        cartItems: cartItems,
        paymentMethod: paymentMethod,
        diningLocation: diningLocation,
        orderNumber: orderNumber,
        receiptOption: receiptOption,
        fontScale: 1.1,
        paddingScale: 1.2,
      ),
      desktop: _ReceiptContent(
        cartItems: cartItems,
        paymentMethod: paymentMethod,
        diningLocation: diningLocation,
        orderNumber: orderNumber,
        receiptOption: receiptOption,
        fontScale: 1.3,
        paddingScale: 1.5,
      ),
    );
  }
}

class _ReceiptContent extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String paymentMethod;
  final String diningLocation;
  final String receiptOption;
  final int orderNumber;
  final double fontScale;
  final double paddingScale;

  const _ReceiptContent({
    required this.cartItems,
    required this.paymentMethod,
    required this.diningLocation,
    required this.receiptOption,
    required this.orderNumber,
    required this.fontScale,
    required this.paddingScale,
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
            Image.asset("assets/images/wacologo.png", height: 80 * fontScale),
            const SizedBox(height: 10),
            Text(
              "The WaCo - San Jose",
              style: TextStyle(
                fontSize: 22 * fontScale,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4226),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Order Receipt",
              style: TextStyle(
                fontSize: 26 * fontScale,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4226),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Order No: #$orderNumber",
              style: TextStyle(
                fontSize: 18 * fontScale,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Item List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20 * paddingScale),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6 * paddingScale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        item["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B4226),
                          fontSize: 16 * fontScale,
                        ),
                      ),
                      subtitle: Text("Qty: ${item["qty"]}"),
                      trailing: Text(
                        "₱${item["price"] * item["qty"]}",
                        style: TextStyle(
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 20 * paddingScale, vertical: 10 * paddingScale),
              height: 2,
              color: const Color(0xFF6B4226),
            ),

            Text(
              "Total: ₱$total",
              style: TextStyle(
                fontSize: 26 * fontScale,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4226),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * paddingScale),
              child: Column(
                children: [
                  Text("Payment Method: $paymentMethod",
                      style: TextStyle(fontSize: 16 * fontScale)),
                  Text("Dining: $diningLocation",
                      style: TextStyle(fontSize: 16 * fontScale)),
                  Text("Receipt: $receiptOption",
                      style: TextStyle(fontSize: 16 * fontScale)),
                ],
              ),
            ),

            const SizedBox(height: 25),

            if (paymentMethod == "Cashless") ...[
              const SizedBox(height: 25),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(20 * paddingScale),
                  child: Column(
                    children: [
                      Text(
                        "Scan to Pay with GCash/PayMaya",
                        style: TextStyle(
                          fontSize: 18 * fontScale,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B4226),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Image.asset(
                        "assets/images/qr.png",
                        width: 150 * fontScale,
                        height: 150 * fontScale,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4226),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 60 * paddingScale, vertical: 20 * paddingScale),
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
                  // ✅ Go back to SplashScreen (main.dart)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                    (route) => false,
                  );
                });
              },
              child: Text(
                "Back to Home",
                style: TextStyle(
                  fontSize: 20 * fontScale,
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
