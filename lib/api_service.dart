import 'dart:convert';
import 'package:http/http.dart' as http;

const String _baseUrl = 'http://192.168.100.8/waco_api/';

/// -----------------------------------------------------------
/// Upload order to server (send to XAMPP backend)
/// -----------------------------------------------------------
Future<bool> uploadOrder({
  required int orderNumber,
  required List<Map<String, dynamic>> cartItems,
  required String paymentMethod,
  required String diningLocation,
  required String receiptOption,
}) async {
  final url = Uri.parse('${_baseUrl}orders.php');
  final total = cartItems.fold<int>(
    0,
    (sum, item) => sum + (item["price"] as int) * (item["qty"] as int),
  );

  final orderData = {
    'Order_no': 'ORD$orderNumber',
    'Status': 'Pending',
    'Dining_option': diningLocation,
    'Products_id': cartItems.map((e) => e["id"]).join(','), // Comma-separated IDs
    'Orders': cartItems.map((e) => "${e["name"]} x${e["qty"]}").join(', '),
    'Total_price': total.toString(),
    'Amount_of_bill': total.toString(),
    'Payment_method': paymentMethod,
    'Gcash_reference': paymentMethod == "Cashless" ? "GCASH123" : "",
    'receipt': receiptOption,
  };

  try {
    final res = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json, text/plain, */*',
          },
          body: jsonEncode(orderData),
        )
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      try {
        final result = jsonDecode(res.body);
        final success = (result is Map &&
            (result['success'] == true ||
                '${result['success']}'.toLowerCase() == 'true'));
        if (success) return true;
      } catch (_) {
        final trimmed = res.body.trim().toLowerCase();
        if (trimmed == '1' || trimmed == 'ok') return true;
      }
    }
    return false;
  } catch (e) {
    print("Error uploading order: $e");
    return false;
  }
}

/// -----------------------------------------------------------
/// Fetch product list from XAMPP (auto-update kiosk menu)
/// -----------------------------------------------------------
Future<List<Map<String, dynamic>>> fetchProducts() async {
  final url = Uri.parse('${_baseUrl}get_products.php');

  try {
    final res = await http
        .get(
          url,
          headers: {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      if (data is Map && data['success'] == true && data['products'] != null) {
        return List<Map<String, dynamic>>.from(data['products']);
      } else {
        print('Invalid product data format: $data');
      }
    } else {
      print('HTTP error: ${res.statusCode}');
    }
  } catch (e) {
    print('Error fetching products: $e');
  }

  // Return empty list if something goes wrong
  return [];
}
