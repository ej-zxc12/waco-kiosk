import 'package:flutter/material.dart';
import 'helpers.dart';

/// ✅ ProductDetailsScreen is now ONLY for MilkTea
class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String imagePath;
  final List<Map<String, dynamic>> options; // MilkTea sizes (16oz, 22oz)

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

  void _updateGrandTotal(int total) {
    setState(() {
      _grandTotal = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: const Color(0xFF6B4226),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
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

            /// ✅ Sizes Section
            ExpandableSection(
              title: "Choose Size",
              options: widget.options,
              onTotalChanged: _updateGrandTotal,
            ),

            const SizedBox(height: 20),

            /// ✅ Grand Total
            if (_grandTotal > 0)
              Center(
                child: Text(
                  "Grand Total: ₱$_grandTotal",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 40),

            /// ✅ Place Order Button
            AnimatedButton(
              label: "Place Order",
              onPressed: () {
                if (_grandTotal == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please add at least 1 item.")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Order placed. Total ₱$_grandTotal")),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
