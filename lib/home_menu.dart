import 'dart:async';
import 'package:flutter/material.dart';
import 'dining_location.dart';
import 'helpers.dart';
import 'cart_screen.dart';
import 'api_service.dart'; // ✅ Import your API connection file

// ✅ Import your product screens (still works fine)
import 'milktea_screen.dart';
import 'iced_coffee_screen.dart';
import 'fruit_soda_screen.dart';
import 'fruit_yogurt_screen.dart';
import 'waffle_screen.dart';

/// 🔹 Global cart counter
ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

/// 🔹 Global cart items list
List<Map<String, dynamic>> cartItems = [];

class HomeMenu extends StatefulWidget {
  final String diningLocation;

  const HomeMenu({super.key, required this.diningLocation});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    // ✅ Auto-refresh every 15 seconds to get new/updated products
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await fetchProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  /// Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiningLocationScreen(),
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
                                    diningLocation: widget.diningLocation,
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

            /// MENU GRID OR LOADING STATE
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6B4226),
                      ),
                    )
                  : _products.isEmpty
                      ? const Center(
                          child: Text(
                            "No products available.",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: _products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 25,
                          ),
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return buildMenuItem(
                              context,
                              product['category'] ?? 'UNKNOWN',
                              product['image'] ??
                                  'assets/images/default_product.png',
                            );
                          },
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
    );
  }

  /// 🔹 Menu Item Builder
  Widget buildMenuItem(BuildContext context, String title, String imagePath) {
    return AnimatedScaleButton(
      onTap: () {
        if (title.toUpperCase().contains("MILKTEA")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MilkteaScreen(diningLocation: widget.diningLocation),
            ),
          );
        } else if (title.toUpperCase().contains("COFFEE")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  IcedCoffeeScreen(diningLocation: widget.diningLocation),
            ),
          );
        } else if (title.toUpperCase().contains("SODA")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FruitSodaScreen(diningLocation: widget.diningLocation),
            ),
          );
        } else if (title.toUpperCase().contains("YOGURT")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FruitYogurtScreen(diningLocation: widget.diningLocation),
            ),
          );
        } else if (title.toUpperCase().contains("WAFFLE")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WaffleScreen(diningLocation: widget.diningLocation),
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
                child: Image.network( // ✅ Load product images from server
                  imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/default_product.png');
                  },
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
