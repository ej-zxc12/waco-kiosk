import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DatabaseProductsSection extends StatefulWidget {
  const DatabaseProductsSection({super.key});

  @override
  State<DatabaseProductsSection> createState() =>
      _DatabaseProductsSectionState();
}

class _DatabaseProductsSectionState extends State<DatabaseProductsSection> {
  List<dynamic> products = [];
  bool isLoading = true;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    // Auto-refresh every 1 minute
    refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchProducts();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    try {
      // ⚠️ Replace with your computer’s local IP or server address
      final response = await http.get(
        Uri.parse('http://192.168.137.9/waco_api/get_products.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            products = data['products'];
          });
        } else {
          products = [];
        }
      } else {
        debugPrint("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "NEW PRODUCTS",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                : products.isEmpty
                    ? const Center(
                        child: Text(
                          "No new products available.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          // Get actual fields from your database
                          final productName = product["Product_Name"] ?? "Unnamed";
                          final price = product["Price"] ?? "0.00";
                          final imageUrl = product["Product_Image"] != null &&
                                  product["Product_Image"].toString().isNotEmpty
                              ? 'http://192.168.137.9/waco_api/uploads/${product["Product_Image"]}'
                              : null;

                          return Container(
                            width: 180,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.brown, width: 2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(3, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: imageUrl != null
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(Icons.image_not_supported,
                                                  size: 50, color: Colors.brown);
                                            },
                                          )
                                        : const Icon(Icons.local_cafe,
                                            size: 50, color: Colors.brown),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  productName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "₱${price.toString()}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
