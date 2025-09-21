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
      children: [
        IconButton(
          icon: Image.asset(
            "assets/images/cart logo.png", // ✅ your uploaded cart image
            width: 40,
            height: 40,
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
        Positioned(
          right: 0,
          top: 0,
          child: ValueListenableBuilder<int>(
            valueListenable: cartItemCount,
            builder: (context, count, _) {
              if (count == 0) return const SizedBox();
              return Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$count",
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
