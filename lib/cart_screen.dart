import 'package:flutter/material.dart';
import 'home_menu.dart';
import 'PaymentMethodScreen.dart';

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

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    cartItemCount.value =
        cartItems.fold<int>(0, (sum, item) => sum + item["qty"] as int);
  }

  void _increaseItem(int index) {
    setState(() {
      cartItems[index]["qty"] += 1;
      cartItemCount.value =
          cartItems.fold<int>(0, (sum, item) => sum + item["qty"] as int);
    });
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
  }

  void _removeItem(int index) async {
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

  void _clearCart() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cart"),
        content: const Text("Are you sure you want to remove all items?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Clear"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        cartItems.clear();
        cartItemCount.value = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🗑 Cart has been cleared.")),
      );
    }
  }

  void _goToPayment() {
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

    return Scaffold(
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
                          builder: (context) =>
                              HomeMenu(diningLocation: widget.diningLocation),
                        ),
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text(
                      "Go Back to Menu",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                /// 🔹 Dining Location Banner
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

                /// 🔹 Cart Items
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
                          displayName = "${item["name"]} (${item["size"]})";
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
                                      borderRadius: BorderRadius.circular(8),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "₱${item["price"]} × ${item["qty"]} = ₱$itemTotal",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Color(0xFF6B4226)),
                                          onPressed: () =>
                                              _decreaseItem(index),
                                        ),
                                        Text(
                                          "${item["qty"]}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle,
                                              color: Color(0xFF6B4226)),
                                          onPressed: () =>
                                              _increaseItem(index),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.delete_forever,
                                              color: Colors.redAccent),
                                          tooltip: "Remove item",
                                          onPressed: () => _removeItem(index),
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

                /// 🔹 Checkout Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            onPressed: isCartEmpty ? null : _goToPayment,
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
                                diningLocation: widget.diningLocation,
                              ),
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
                          side: const BorderSide(color: Colors.brown, width: 2),
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
    );
  }
}
