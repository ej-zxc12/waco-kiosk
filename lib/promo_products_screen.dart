import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_menu.dart' show cartItemCount, cartItems;

class PromoProductsScreen extends StatefulWidget {
  final String diningLocation;

  const PromoProductsScreen({super.key, required this.diningLocation});

  @override
  State<PromoProductsScreen> createState() => _PromoProductsScreenState();
}

class _PromoProductsScreenState extends State<PromoProductsScreen> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPromoProducts();
  }

  Future<void> fetchPromoProducts() async {
    setState(() => isLoading = true);

    try {
      // ⚠️ Replace this with your XAMPP server's local IP address
      final response = await http.get(
        Uri.parse('http://192.168.100.8/waco_api/get_products.php?category=promo'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            products = data['products'];
          });
        } else {
          setState(() {
            products = [];
          });
        }
      } else {
        debugPrint("Server returned ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching promo products: $e");
    }

    setState(() => isLoading = false);
  }

  void addToCart(Map<String, dynamic> product) {
    cartItems.add({
      "name": product["name"],
      "price": double.tryParse(product["price"].toString()) ?? 0,
      "quantity": 1,
    });
    cartItemCount.value++;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product["name"]} added to cart"),
        backgroundColor: Colors.brown,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.black, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "PROMO PRODUCTS",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            /// 🔹 BODY CONTENT
            Expanded(
              child: isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF6B4226)),
                    )
                  : products.isEmpty
                      ? const Center(
                          child: Text(
                            "No promo products available.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 25,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final name = product["name"];
                            final price = product["price"];
                            final imageUrl =
                                'http://192.168.137.9/waco_api/uploads/${product["image"]}';

                            return GestureDetector(
                              onTap: () => addToCart(product),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: Colors.brown, width: 3),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(3, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.brown,
                                              size: 50,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF6B4226),
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(18),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "₱$price",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
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
          ],
        ),
      ),
    );
  }
}
