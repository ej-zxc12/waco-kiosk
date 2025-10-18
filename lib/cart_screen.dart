import 'dart:async';
import 'package:flutter/material.dart';
import 'home_menu.dart';
import 'PaymentMethodScreen.dart';
import 'main.dart'; // ✅ For SplashScreen

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String diningLocation;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.diningLocation,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> cartItems;
  Timer? _idleTimer;
  Timer? _countdownTimer;
  int _countdown = 15; // seconds before returning
  bool _showCountdown = false;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    cartItemCount.value =
        cartItems.fold<int>(0, (sum, item) => sum + item["qty"] as int);
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _resetIdleTimer();
  }

  // 🕒 Reset idle timer on interaction
  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _countdownTimer?.cancel();
    _fadeController.reverse();
    _showCountdown = false;
    _countdown = 15;

    // Start idle timer: 60 seconds inactivity
    _idleTimer = Timer(const Duration(seconds: 60), () {
      setState(() {
        _showCountdown = true;
        _fadeController.forward();
      });
      _startCountdown();
    });
  }

  // ⏳ Countdown before reset
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _fadeController.reverse();
        _handleAutoReturn();
      }
    });
  }

  // 🚀 After countdown finishes: clear all and return to main.dart
  void _handleAutoReturn() {
    if (!mounted) return;

    setState(() {
      cartItems.clear();
      cartItemCount.value = 0;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _countdownTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _increaseItem(int index) {
    setState(() {
      cartItems[index]["qty"] += 1;
      cartItemCount.value =
          cartItems.fold<int>(0, (sum, item) => sum + item["qty"] as int);
    });
    _resetIdleTimer();
  }

  void _decreaseItem(int index) {
    setState(() {
      if (cartItems[index]["qty"] > 1) {
        cartItems[index]["qty"] -= 1;
      } else {
        cartItems.removeAt(index);
      }
      cartItemCount.value =
          cartItems.fold<int>(0, (sum, item) => sum + item["qty"] as int);
    });
    _resetIdleTimer();
  }

  void _removeItem(int index) async {
    _resetIdleTimer();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Item"),
        content: Text(
          "Are you sure you want to remove '${cartItems[index]["name"]}' from your cart?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Remove"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        cartItems.removeAt(index);
        cartItemCount.value =
            cartItems.fold<int>(0, (sum, item) => sum + item["qty"] as int);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🗑 Item removed from cart.")),
      );
    }
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
      cartItemCount.value = 0;
    });
  }

  void _goToPayment() {
    _resetIdleTimer();
    if (cartItems.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          cartItems: cartItems,
          diningLocation: widget.diningLocation,
        ),
      ),
    );
  }

  int _calculateTotal() {
    return cartItems.fold<int>(
      0,
      (sum, item) => sum + (item["price"] as int) * (item["qty"] as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();
    final isCartEmpty = cartItems.isEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetIdleTimer,
      onPanDown: (_) => _resetIdleTimer(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color(0xFFF5E6D3),
            appBar: AppBar(
              title: const Text("Your Cart"),
              backgroundColor: const Color(0xFF6B4226),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: "Clear Cart",
                  onPressed: _clearCart,
                ),
              ],
            ),
            body: isCartEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "🛒 Your cart is empty.",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeMenu(
                                    diningLocation: widget.diningLocation),
                              ),
                            );
                          },
                          icon: const Icon(Icons.home),
                          label: const Text(
                            "Return to Home Menu",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4226),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: Colors.brown.shade200,
                        child: Text(
                          "Dining Location: ${widget.diningLocation}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final itemTotal =
                                (item["price"] as int) * (item["qty"] as int);
                            String displayName = item["name"];
                            if (item["size"] != null &&
                                item["size"].toString().isNotEmpty) {
                              if (!displayName.contains(item["size"])) {
                                displayName =
                                    "${item["name"]} (${item["size"]})";
                              }
                            }
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    item["imagePath"] != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              item["imagePath"],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(Icons.local_drink,
                                            color: Colors.brown, size: 40),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayName,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "₱${item["price"]} × ${item["qty"]} = ₱$itemTotal",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.remove_circle,
                                                    color: Color(0xFF6B4226)),
                                                onPressed: () =>
                                                    _decreaseItem(index),
                                              ),
                                              Text(
                                                "${item["qty"]}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.add_circle,
                                                    color: Color(0xFF6B4226)),
                                                onPressed: () =>
                                                    _increaseItem(index),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.redAccent),
                                                tooltip: "Remove item",
                                                onPressed: () =>
                                                    _removeItem(index),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total: ₱$total",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed:
                                      isCartEmpty ? null : _goToPayment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isCartEmpty
                                        ? Colors.grey
                                        : const Color(0xFF6B4226),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    isCartEmpty
                                        ? "Checkout Disabled"
                                        : "Proceed to Payment",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isCartEmpty
                                          ? Colors.black54
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeMenu(
                                        diningLocation:
                                            widget.diningLocation),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart,
                                  color: Colors.brown),
                              label: const Text(
                                "Add More Items",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.brown, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),

          // 🔹 Countdown overlay (with fade animation)
          if (_showCountdown)
            FadeTransition(
              opacity: _fadeController,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_rounded,
                            color: Colors.brown, size: 60),
                        const SizedBox(height: 10),
                        const Text(
                          "No activity detected...",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Returning to main screen in $_countdown seconds",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _resetIdleTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4226),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Continue Ordering",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
