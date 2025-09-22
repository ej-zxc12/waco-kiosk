import 'package:flutter/material.dart';
import 'home_menu.dart'; // ✅ contains global cartItems & cartItemCount
import 'cart_screen.dart';
import 'helpers.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String imagePath;
  final List<Map<String, dynamic>> options; // e.g. MilkTea sizes
  final String diningLocation; // ✅ keep dining location context

  const ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.imagePath,
    required this.options,
    required this.diningLocation,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _grandTotal = 0;
  List<Map<String, dynamic>> _selectedItems = [];
  int _resetKey = 0; // 🔹 force reset for ExpandableSection

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
      final sizeLabel = item["label"]?.toString() ?? "";

      final displayName = sizeLabel.isNotEmpty
          ? "${widget.productName} ($sizeLabel)"
          : widget.productName;

      final newItem = {
        "name": displayName,
        "price": item["price"],
        "qty": item["qty"],
        "size": sizeLabel,
        "imagePath": widget.imagePath,
      };

      final existingIndex = cartItems.indexWhere(
        (e) => e["name"] == newItem["name"] && e["size"] == newItem["size"],
      );

      if (existingIndex != -1) {
        cartItems[existingIndex]["qty"] += newItem["qty"] as int;
      } else {
        cartItems.add(newItem);
      }
    }

    cartItemCount.value =
        cartItems.fold<int>(0, (sum, item) => sum + (item["qty"] as int));

    // ✅ Reset selections after adding to cart
    setState(() {
      _grandTotal = 0;
      _selectedItems.clear();
      _resetKey++; // 🔹 force ExpandableSection to reset its state
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Item(s) added to cart.")),
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
          ValueListenableBuilder<int>(
            valueListenable: cartItemCount,
            builder: (context, count, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 6, bottom: 6),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
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
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.brown, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/cart_logo.png",
                          height: 30,
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
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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

            ExpandableSection(
              key: ValueKey(_resetKey), // 🔹 forces rebuild when reset
              title: "Choose Size",
              options: widget.options,
              onTotalChanged: _updateGrandTotal,
            ),

            const SizedBox(height: 20),

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

            // ✅ Add to Cart button (always a function, check inside)
            AnimatedButton(
              label: "Add to Cart",
              onPressed: () {
                if (_grandTotal > 0 && _selectedItems.isNotEmpty) {
                  _placeOrder(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("⚠️ Please select an item.")),
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeMenu(
                        diningLocation: widget.diningLocation,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, color: Colors.brown),
                label: const Text(
                  "Add More Items",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.brown, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
