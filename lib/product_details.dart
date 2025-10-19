import 'package:flutter/material.dart';
import 'home_menu.dart'; // ✅ contains global cartItems & cartItemCount
import 'cart_screen.dart';
import 'helpers.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String imagePath;
  final List<Map<String, dynamic>> options;
  final String diningLocation;

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
      _resetKey++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Item(s) added to cart.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide;
    final s = (shortest / 800).clamp(0.8, 1.6);
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4226),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: cartItemCount,
            builder: (context, count, _) {
              return Padding(
                padding: EdgeInsets.only(right: 12.0 * s, top: 6 * s, bottom: 6 * s),
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
                        padding: EdgeInsets.all(10 * s),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.brown, width: 2 * s),
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
                          height: 30 * s,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        right: -4 * s,
                        top: -4 * s,
                        child: Container(
                          padding: EdgeInsets.all(5 * s),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$count",
                            style: TextStyle(
                              fontSize: 12 * s,
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
        padding: EdgeInsets.all(16 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🧇 Product Image
            Center(
              child: Container(
                height: 160 * s,
                width: 160 * s,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.brown.shade700, width: 2 * s),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(3, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0 * s),
                  child: Image.asset(widget.imagePath, fit: BoxFit.contain),
                ),
              ),
            ),

            SizedBox(height: 12 * s),

            // 🧾 Product Name below image
            Text(
              widget.productName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24 * s,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4226),
              ),
            ),

            SizedBox(height: 20 * s),

            ExpandableSection(
              key: ValueKey(_resetKey),
              title: "Choose Size",
              options: widget.options,
              onTotalChanged: _updateGrandTotal,
            ),

            SizedBox(height: 20 * s),

            if (_grandTotal > 0)
              Text(
                "Grand Total: ₱$_grandTotal",
                style: TextStyle(
                  fontSize: 20 * s,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),

            SizedBox(height: 40 * s),

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

            SizedBox(height: 16 * s),

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
                label: Text(
                  "Add More Items",
                  style: TextStyle(
                    fontSize: 16 * s,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.brown, width: 2 * s),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30 * s),

            // 🕒 Order Processing Note
            Container(
              padding: EdgeInsets.all(14 * s),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.brown.shade300, width: 1.5 * s),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, color: Color.fromARGB(255, 9, 7, 6)),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Your order will be processed within 3–5 minutes depending on queue.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 15, 13, 11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20 * s),
          ],
        ),
      ),
    );
  }
}

