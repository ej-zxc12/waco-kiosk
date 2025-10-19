import 'package:flutter/material.dart';
import 'home_menu.dart'; // for global cartItems & cartItemCount
import 'cart_screen.dart';

class WaffleDetailsScreen extends StatefulWidget {
  final String name;
  final int price;
  final String imagePath;
  final String diningLocation;

  const WaffleDetailsScreen({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.diningLocation,
  });

  @override
  State<WaffleDetailsScreen> createState() => _WaffleDetailsScreenState();
}

class _WaffleDetailsScreenState extends State<WaffleDetailsScreen> {
  int quantity = 0;
  bool withCaramel = false;
  bool withChocolate = false;

  void _increaseQty() => setState(() => quantity++);
  void _decreaseQty() => setState(() {
        if (quantity > 0) quantity--;
      });

  int _calculateTotal() {
    if (quantity == 0) return 0;
    int baseTotal = widget.price * quantity;

    if (withCaramel) baseTotal += 10 * quantity;
    if (withChocolate) baseTotal += 10 * quantity;

    return baseTotal;
  }

  void _addToCart(BuildContext context) {
    if (quantity == 0) return;

    // 🧇 Create a descriptive name for Plain Waffle
    String finalName = widget.name;
    if (widget.name == "Plain Waffle") {
      if (withCaramel && withChocolate) {
        finalName = "Plain Waffle + Caramel & Chocolate Syrup";
      } else if (withCaramel) {
        finalName = "Plain Waffle + Caramel Syrup";
      } else if (withChocolate) {
        finalName = "Plain Waffle + Chocolate Syrup";
      }
    }

    final existingIndex = cartItems.indexWhere(
      (item) => item["name"] == finalName && item["imagePath"] == widget.imagePath,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex]["qty"] += quantity;
    } else {
      cartItems.add({
        "name": finalName,
        "price": widget.price +
            ((withCaramel ? 10 : 0) + (withChocolate ? 10 : 0)),
        "qty": quantity,
        "imagePath": widget.imagePath,
        "size": "",
        "withCaramel": withCaramel,
        "withChocolate": withChocolate,
      });
    }

    cartItemCount.value =
        cartItems.fold<int>(0, (sum, item) => sum + (item["qty"] as int));

    setState(() {
      quantity = 0;
      withCaramel = false;
      withChocolate = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cartItems,
          diningLocation: widget.diningLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateTotal();
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide;
    final s = (shortest / 800).clamp(0.8, 1.6);

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4226),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Waffle Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          /// 🧇 Product Image
          Container(
            color: const Color(0xFFF5E6D3),
            padding: EdgeInsets.all(16 * s),
            child: Center(
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
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.all(24 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 24 * s,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(height: 8 * s),
                          Text(
                            "₱${widget.price}",
                            style: TextStyle(
                              fontSize: 18 * s,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 20 * s),

                          /// 🔹 Add-on Options
                          if (widget.name == "Plain Waffle") ...[
                            CheckboxListTile(
                              value: withCaramel,
                              activeColor: Colors.brown,
                              onChanged: (val) =>
                                  setState(() => withCaramel = val ?? false),
                              title: Text(
                                "Add Caramel Syrup (+₱10 each)",
                                style: TextStyle(fontSize: 16 * s),
                              ),
                            ),
                            CheckboxListTile(
                              value: withChocolate,
                              activeColor: Colors.brown,
                              onChanged: (val) =>
                                  setState(() => withChocolate = val ?? false),
                              title: Text(
                                "Add Chocolate Syrup (+₱10 each)",
                                style: TextStyle(fontSize: 16 * s),
                              ),
                            ),
                          ],

                          SizedBox(height: 10 * s),

                          /// 🔹 Quantity Selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _decreaseQty,
                                icon: Icon(Icons.remove_circle,
                                    color: Colors.brown, size: 32 * s),
                              ),
                              Text(
                                "$quantity",
                                style: TextStyle(
                                  fontSize: 22 * s,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: _increaseQty,
                                icon: Icon(Icons.add_circle,
                                    color: Colors.brown, size: 32 * s),
                              ),
                            ],
                          ),

                          /// 🔹 Total Price
                          if (quantity > 0) ...[
                            SizedBox(height: 10 * s),
                            Text(
                              "Total: ₱$totalPrice",
                              style: TextStyle(
                                fontSize: 20 * s,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],

                          SizedBox(height: 20 * s),

                          /// 🕒 Order notice
                          Container(
                            padding: EdgeInsets.all(12 * s),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              border: Border.all(color: Colors.orange.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time,
                                    color: Colors.orange, size: 20),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Your order will be processed within 3–5 minutes depending on queue.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16 * s),

                  /// 🔹 Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          quantity == 0 ? null : () => _addToCart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quantity == 0
                            ? Colors.grey
                            : const Color(0xFF6B4226),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30 * s, vertical: 14 * s),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 18 * s,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
