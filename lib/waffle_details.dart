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
  int quantity = 0; // ✅ default is NONE (0)
  bool withCaramel = false;

  void _increaseQty() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQty() {
    setState(() {
      if (quantity > 0) quantity--;
    });
  }

  int _calculateTotal() {
    if (quantity == 0) return 0;
    int baseTotal = widget.price * quantity;
    if (withCaramel) {
      baseTotal += 10 * quantity; // ✅ caramel +10 each waffle
    }
    return baseTotal;
  }

  void _addToCart(BuildContext context) {
    if (quantity == 0) return; // prevent adding nothing

    final existingIndex = cartItems.indexWhere(
      (item) =>
          item["name"] == widget.name &&
          item["imagePath"] == widget.imagePath &&
          item["withCaramel"] == withCaramel,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex]["qty"] += quantity;
    } else {
      cartItems.add({
        "name": widget.name + (withCaramel ? " + Caramel" : ""),
        "price": widget.price + (withCaramel ? 10 : 0),
        "qty": quantity,
        "imagePath": widget.imagePath,
        "size": "",
        "withCaramel": withCaramel,
      });
    }

    cartItemCount.value =
        cartItems.fold<int>(0, (sum, item) => sum + (item["qty"] as int));

    // ✅ Reset after adding
    setState(() {
      quantity = 0;
      withCaramel = false;
    });

    // ✅ Go to Cart
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4226),
        elevation: 0,
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          /// 🖼️ Product Image
          Container(
            color: const Color(0xFFF5E6D3),
            child: Image.asset(
              widget.imagePath,
              width: double.infinity,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),

          /// 🔹 Product Info
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₱${widget.price}" +
                        (widget.name == "Plain Waffle"
                            ? " (+₱10 Caramel option)"
                            : ""),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 Caramel Option (Plain Waffle only)
                  if (widget.name == "Plain Waffle")
                    Row(
                      children: [
                        Checkbox(
                          value: withCaramel,
                          activeColor: Colors.brown,
                          onChanged: (val) {
                            setState(() {
                              withCaramel = val ?? false;
                            });
                          },
                        ),
                        const Text(
                          "Add Caramel (+₱10 each)",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                  /// 🔹 Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _decreaseQty,
                        icon: const Icon(Icons.remove_circle,
                            color: Colors.brown, size: 32),
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _increaseQty,
                        icon: const Icon(Icons.add_circle,
                            color: Colors.brown, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 Total Price (only show if qty > 0)
                  if (quantity > 0)
                    Center(
                      child: Text(
                        "Total: ₱$totalPrice",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  const Spacer(),

                  /// 🔹 Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: quantity == 0 ? null : () => _addToCart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quantity == 0
                            ? Colors.grey
                            : const Color(0xFF6B4226),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 18,
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
