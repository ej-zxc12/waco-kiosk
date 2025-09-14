import 'package:flutter/material.dart';
import 'helpers.dart'; // ✅ Reuse AnimatedButton

class WaffleDetailsScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final int basePrice;
  final bool withCaramel; // ✅ special handling for plain waffle

  const WaffleDetailsScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.basePrice,
    this.withCaramel = false,
  });

  @override
  State<WaffleDetailsScreen> createState() => _WaffleDetailsScreenState();
}

class _WaffleDetailsScreenState extends State<WaffleDetailsScreen> {
  int _quantity = 0;
  bool _addCaramel = false;

  int get _unitPrice {
    if (widget.withCaramel && _addCaramel) {
      return widget.basePrice + 10; // Plain Waffle + Caramel
    }
    return widget.basePrice;
  }

  int get _totalPrice => _quantity * _unitPrice;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: const Text("Waffle Details"),
        backgroundColor: const Color(0xFF6B4226),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// IMAGE
            Container(
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

            const SizedBox(height: 12),

            /// PRODUCT NAME (under image ✅)
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ Caramel option (only for Plain Waffle)
            if (widget.withCaramel)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _addCaramel,
                    onChanged: (val) {
                      setState(() => _addCaramel = val ?? false);
                    },
                  ),
                  const Text(
                    "Add Caramel (+₱10)",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// ✅ Price per piece
            Text(
              "₱$_unitPrice each",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove_circle, size: 32),
                ),
                Text(
                  "$_quantity",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _increment,
                  icon: const Icon(Icons.add_circle, size: 32),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ✅ Grand Total
            if (_totalPrice > 0)
              Text(
                "Grand Total: ₱$_totalPrice",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 40),

            /// ✅ Place Order Button
            AnimatedButton(
              label: "Place Order",
              onPressed: () {
                if (_quantity == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please select at least 1 waffle.")),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Order placed: $_quantity x ${widget.title} = ₱$_totalPrice"),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
