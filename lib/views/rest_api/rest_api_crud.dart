import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model./model.dart';


class ApiService {
  final String baseUrl = "https://crud.teamrabbil.com/api/v1";

  // Create
  Future<bool> createProduct(Api product) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/CreateProduct"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Read
  Future<List<Api>?> getProducts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/ReadProduct"));
      if (response.statusCode == 200) {
        return apiFromJson(response.body);
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Update
  Future<bool> updateProduct(String id, Api product) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/UpdateProduct/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Delete
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/DeleteProduct/$id"),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
