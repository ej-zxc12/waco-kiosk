import 'package:flutter/material.dart';
import 'cart_screen.dart';

class CartButton extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartButton({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingActionButton(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.brown, width: 2),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(cartItems: cartItems),
              ),
            );
          },
          child: Image.asset(
            "assets/images/waco_bag.png", // ✅ bag icon
            height: 35,
          ),
        ),
        if (cartItems.isNotEmpty)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${cartItems.length}", // ✅ show count
                style: const TextStyle(
                  fontSize: 12,
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
