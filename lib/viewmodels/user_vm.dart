// api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_uas/models/model.dart';

class ApiService {
  final String apiUrl = 'http://192.168.1.5:5000';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$apiUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson
          .map((productJson) => Product.fromJson(productJson))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<dynamic> saveProduct(
    String name,
    int price,
    String desk,
    String category,
    String? pickedImagePath,
    String url, // Change this to String
  ) async {
    List<int> imageBytes = await pickedImagePath != null
        ? await File(pickedImagePath!).readAsBytes()
        : <int>[];

    // Base64 encode the image bytes
    // ignore: unused_local_variable
    String imageBase64 = base64Encode(imageBytes);
    Map data = {
      "name": name,
      "price": price,
      "desk": desk,
      "category": category,
      "image": pickedImagePath,
      "url": imageBase64,
    };
    try {
      http.Response hasil = await http.post(Uri.parse('$apiUrl/products'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: json.encode(data));
      if (hasil.statusCode == 200) {
        return true;
      } else {
        // print("error status " + hasil.statusCode.toString());
        return false;
      }
    } catch (e) {
      // print("error catch $e");
      return false;
    }
  }

  Future<dynamic> updateProduct(int id, Map<String, dynamic> product) async {
    final response = await http.patch(
      Uri.parse('$apiUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<dynamic> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/products/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
