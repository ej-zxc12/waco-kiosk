import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'home_menu.dart'; // ✅ for global cartItems

class CartButton extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String diningLocation; // ✅ dining location passed from HomeMenu

  const CartButton({
    super.key,
    required this.cartItems,
    required this.diningLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Image.asset(
            "assets/images/cart_logo.png", // ✅ renamed (no spaces!)
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              // Fallback icon if asset not found
              return const Icon(Icons.shopping_cart, size: 40, color: Colors.brown);
            },
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(
                  cartItems: cartItems,
                  diningLocation: diningLocation, // ✅ pass dining location
                ),
              ),
            );
          },
        ),

        /// 🔹 Badge counter
        Positioned(
          right: 2,
          top: 2,
          child: ValueListenableBuilder<int>(
            valueListenable: cartItemCount,
            builder: (context, count, _) {
              if (count == 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  count > 99 ? "99+" : "$count", // ✅ handles big numbers
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
