import 'dart:async';
import 'package:flutter/material.dart';
import 'home_menu.dart';
import 'dining_location.dart';
import 'receipt_option_screen.dart';
import 'main.dart'; // ✅ For SplashScreen access

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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "No",
                style: TextStyle(fontSize: 18, color: Colors.black87),
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
                    builder: (context) => const DiningLocationScreen(),
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
    return IdleWrapper( // ✅ Auto timeout protection
      idleDuration: const Duration(seconds: 60),
      child: Scaffold(
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

              // ✅ Payment Options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _goToReceiptOption(context, "Pay at the Counter"),
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
                  GestureDetector(
                    onTap: () => _goToReceiptOption(context, "Cashless"),
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

              // ✅ Cancel Order Button
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
      ),
    );
  }
}

/// 🕒 Idle Timeout Wrapper (same as used in HomeMenu)
class IdleWrapper extends StatefulWidget {
  final Widget child;
  final Duration idleDuration;

  const IdleWrapper({
    super.key,
    required this.child,
    this.idleDuration = const Duration(seconds: 60),
  });

  @override
  State<IdleWrapper> createState() => _IdleWrapperState();
}

class _IdleWrapperState extends State<IdleWrapper> {
  Timer? _timer;
  bool _showWarning = false;
  int _countdown = 10;

  void _resetTimer() {
    _timer?.cancel();
    _showWarning = false;
    _countdown = 10;
    _timer = Timer(widget.idleDuration, _onIdle);
  }

  void _onIdle() {
    setState(() => _showWarning = true);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
          );
        }
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onUserActivity([_]) {
    if (_showWarning) {
      setState(() => _showWarning = false);
    }
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onUserActivity,
      child: Stack(
        children: [
          widget.child,
          if (_showWarning)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hourglass_empty, color: Color(0xFF6B4226), size: 60),
                    const SizedBox(height: 12),
                    const Text(
                      "No activity detected",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B4226),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Returning to Home in $_countdown seconds...",
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _onUserActivity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4226),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Continue Order"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
