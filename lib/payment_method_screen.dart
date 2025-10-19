import 'package:flutter/material.dart';
import 'home_menu.dart';
import 'splash_screen.dart';
import 'receipt_option_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String diningLocation;

  const PaymentMethodScreen({
    super.key,
    required this.cartItems,
    required this.diningLocation,
  });

  // ✅ Navigate to receipt option screen
  void _goToReceiptOption(BuildContext context, String method) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptOptionScreen(
          cartItems: cartItems,
          paymentMethod: method,
          diningLocation: diningLocation,
        ),
      ),
    );
  }

  // ✅ Cancel order confirmation
  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final shortest = MediaQuery.of(context).size.shortestSide;
        final s = (shortest / 800).clamp(0.8, 1.6);
        return AlertDialog(
          backgroundColor: const Color(0xFFF5E6D3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Cancel Order?",
            style: TextStyle(
              fontSize: 22 * s,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B4226),
            ),
          ),
          content: Text(
            "Are you sure you want to cancel your order? All items in your cart will be removed.",
            style: TextStyle(fontSize: 18 * s, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "No",
                style: TextStyle(fontSize: 18 * s, color: Colors.black87),
              ),
            ),
            TextButton(
              onPressed: () {
                cartItems.clear();
                cartItemCount.value = 0;
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "Yes, Cancel",
                style: TextStyle(
                  fontSize: 18 * s,
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
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide;
    final s = (shortest / 800).clamp(0.8, 1.6);
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24 * s, horizontal: 16 * s),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Select Payment Method",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28 * s,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B4226),
                ),
              ),
              SizedBox(height: 24 * s),

              // ✅ Payment Options
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 40 * s,
                  runSpacing: 24 * s,
                  children: [
                    _PaymentOption(
                      s: s,
                      assetPath: "assets/images/counter.png",
                      label: "Pay at the Counter",
                      onTap: () => _goToReceiptOption(context, "Pay at the Counter"),
                    ),
                    _PaymentOption(
                      s: s,
                      assetPath: "assets/images/Cashless payment.png",
                      label: "Cashless",
                      onTap: () => _goToReceiptOption(context, "Cashless"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40 * s),

              // ✅ Cancel Order Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 60 * s, vertical: 22 * s),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () => _confirmCancel(context),
                  child: Text(
                    "Cancel Order",
                    style: TextStyle(
                      fontSize: 22 * s,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final double s;
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.s,
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final boxSize = (200 * s).clamp(140.0, 240.0);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            padding: EdgeInsets.all(12 * s),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF6B4226).withOpacity(0.4), width: 2 * s),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(assetPath),
              ),
            ),
          ),
          SizedBox(height: 10 * s),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20 * s,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B4226),
            ),
          ),
        ],
      ),
    );
  }
}
