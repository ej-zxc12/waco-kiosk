import 'package:flutter/material.dart';
import 'home_menu.dart'; // ✅ contains global cartItems & cartItemCount
import 'cart_screen.dart';
import 'helpers.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String imagePath;
  final List<Map<String, dynamic>> options; // e.g. MilkTea sizes

  const ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.imagePath,
    required this.options,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _grandTotal = 0;
  List<Map<String, dynamic>> _selectedItems = [];

  void _updateGrandTotal(int total, List<Map<String, dynamic>> items) {
    setState(() {
      _grandTotal = total;
      _selectedItems = items;
    });
  }

  void _placeOrder(BuildContext context) {
    if (_grandTotal == 0 || _selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please add at least 1 item.")),
      );
      return;
    }

    for (var item in _selectedItems) {
      final existingIndex =
          cartItems.indexWhere((e) => e["name"] == item["name"]);

      if (existingIndex != -1) {
        // ✅ If item already in cart, increase qty
        cartItems[existingIndex]["qty"] += item["qty"];
      } else {
        // ✅ Add new item
        cartItems.add(Map<String, dynamic>.from(item));
      }
    }

    // ✅ Update global cart count
    cartItemCount.value =
        cartItems.fold<int>(0, (sum, item) => sum + (item["qty"] as int));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Added to cart. Total ₱$_grandTotal")),
    );

    // ✅ Navigate to CartScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: const Color(0xFF6B4226),
        actions: [
          // ✅ Cart Icon in AppBar
          ValueListenableBuilder<int>(
            valueListenable: cartItemCount,
            builder: (context, count, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartScreen(cartItems: cartItems),
                        ),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$count",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Product Image
            Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(widget.imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Options Section
            ExpandableSection(
              title: "Choose Size",
              options: widget.options,
              onTotalChanged: _updateGrandTotal,
            ),

            const SizedBox(height: 20),

            // ✅ Show Grand Total
            if (_grandTotal > 0)
              Center(
                child: Text(
                  "Grand Total: ₱$_grandTotal",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),

            const SizedBox(height: 40),

            // ✅ Add to Cart button
            AnimatedButton(
              label: "Add to Cart",
              onPressed: () => _placeOrder(context),
            ),
          ],
        ),
      ),
    );
  }
}
