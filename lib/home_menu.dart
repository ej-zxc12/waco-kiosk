import 'dart:async';
import 'package:flutter/material.dart';
import 'dining_location.dart';
import 'milktea_screen.dart';
import 'iced_coffee_screen.dart';
import 'fruit_soda_screen.dart';
import 'fruit_yogurt_screen.dart';
import 'waffle_screen.dart';
import 'helpers.dart';
import 'cart_screen.dart';
import 'main.dart'; // ✅ for SplashScreen

/// 🔹 Global cart counter
ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

/// 🔹 Global cart items list
List<Map<String, dynamic>> cartItems = [];

class HomeMenu extends StatelessWidget {
  final String diningLocation;

  const HomeMenu({super.key, required this.diningLocation});

  @override
  Widget build(BuildContext context) {
    return IdleWrapper( // ✅ Inactivity watcher
      idleDuration: const Duration(minutes: 1), // 1 minute idle
      child: Scaffold(
        backgroundColor: const Color(0xFFF5E6D3),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    /// Back Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DiningLocationScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.black, size: 28),
                          SizedBox(width: 8),
                          Text(
                            "Back",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "MENU",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),

                    /// Cart Button
                    ValueListenableBuilder<int>(
                      valueListenable: cartItemCount,
                      builder: (context, count, _) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                      cartItems: cartItems,
                                      diningLocation: diningLocation,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(3, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(
                                  "assets/images/cart_logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            if (count > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "$count",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// MENU GRID
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 25,
                  padding: const EdgeInsets.all(24),
                  children: [
                    buildMenuItem(
                        context,
                        "ICED COFFEE",
                        "assets/images/Iced-Coffee_img-removebg-preview.png"),
                    buildMenuItem(context, "MILKTEA",
                        "assets/images/Milktea-removebg-preview.png"),
                    buildMenuItem(context, "FRUIT SODA",
                        "assets/images/FruitSOda-removebg-preview.png"),
                    buildMenuItem(context, "FRUIT YOGURT",
                        "assets/images/Fruit_yogurt-removebg-preview.png"),
                    buildMenuItem(context, "WAFFLE",
                        "assets/images/Waffle Oreo.png"),
                  ],
                ),
              ),

              /// CANCEL ORDER
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedButton(
                    label: "Cancel Order",
                    onPressed: () {
                      showCancelConfirmation(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Menu Item Builder
  Widget buildMenuItem(BuildContext context, String title, String imagePath) {
    return AnimatedScaleButton(
      onTap: () {
        if (title == "MILKTEA") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MilkteaScreen(diningLocation: diningLocation),
            ),
          );
        } else if (title == "ICED COFFEE") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  IcedCoffeeScreen(diningLocation: diningLocation),
            ),
          );
        } else if (title == "FRUIT SODA") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FruitSodaScreen(diningLocation: diningLocation),
            ),
          );
        } else if (title == "FRUIT YOGURT") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FruitYogurtScreen(diningLocation: diningLocation),
            ),
          );
        } else if (title == "WAFFLE") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WaffleScreen(diningLocation: diningLocation),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.brown, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(3, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF6B4226),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🕒 Idle Timeout Wrapper with Data Reset
class IdleWrapper extends StatefulWidget {
  final Widget child;
  final Duration idleDuration;

  const IdleWrapper({
    super.key,
    required this.child,
    this.idleDuration = const Duration(minutes: 1),
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

        // 🧹 Clear all kiosk data before returning home
        cartItems.clear();
        cartItemCount.value = 0;

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
                    const Icon(Icons.hourglass_empty,
                        color: Color(0xFF6B4226), size: 60),
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
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black87),
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
