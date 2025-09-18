import 'package:flutter/material.dart';
import 'cart_screen.dart';

class CartButton extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartButton({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ✅ Custom button with your logo
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(cartItems: cartItems),
              ),
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(12), // more space around the logo
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
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
              "assets/images/cart_logo.png", // ✅ your custom logo
              height: 40, // bigger & clearer
              width: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // ✅ Red badge with item count
        if (cartItems.isNotEmpty)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${cartItems.length}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
