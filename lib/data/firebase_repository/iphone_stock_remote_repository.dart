import 'dart:convert';

import 'package:finish_crud_week8/models/iphone_stock.dart';
import 'package:http/http.dart' as http;

import '../repositories/iphone_stock_repository.dart';

class IphoneStockRemoteRepository extends IPhoneStockRepository {
  final String baseUrl =
      "https://test-xd-9bc10-default-rtdb.asia-southeast1.firebasedatabase.app/";
  final String endpoint = "iphoneStock.json";

  @override
  Future<List<IphoneStock>> getIPhoneStock() async {
    final url = Uri.parse("$baseUrl$endpoint");
    try {
      // Perform a GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final dynamic data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          // Handle Map structure
          return data.entries.map((entry) {
            final id = entry.key;
            final json = entry.value as Map<String, dynamic>;
            return IphoneStockDto.fromJson(id, json);
          }).toList();
        } else if (data is List<dynamic>) {
          // Handle List structure
          return data.where((item) => item != null).map((item) {
            // Use a generated id or pass null if id isn't available
            const generatedId = 'generated_id'; // Replace with actual logic
            return IphoneStockDto.fromJson(
              generatedId,
              item as Map<String, dynamic>,
            );
          }).toList();
        } else {
          throw Exception('Unsupported data structure: ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load iPhone stock: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching iPhone stock: $e');
    }
  }
  
  @override
Future<void> addIPhoneStock(IphoneStock iphoneStock) async {
  final url = Uri.parse("$baseUrl$endpoint");

  try {
    // Convert IphoneStock to JSON using IphoneStockDto
    final Map<String, dynamic> jsonData = IphoneStockDto.toJson(iphoneStock);

    // Perform the POST request
    final response = await http.post(
      url,
      body: json.encode(jsonData),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // Firebase automatically generates an ID and returns it in the response body
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Log the generated ID (key)
      final generatedId = responseBody['name'];
      print('Added iPhone stock with ID: $generatedId');
    } else {
      throw Exception('Failed to add iPhone stock: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error adding iPhone stock: $e');
  }
}

  @override
Future<void> deleteIPhoneStock(String id) async {
  // Append the ID to the endpoint to target the specific item
  final url = Uri.parse("$baseUrl/iphoneStock/$id.json");

  try {
    // Perform the DELETE request
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Success: The stock item is deleted
      print('Successfully deleted iPhone stock with ID: $id');
    } else {
      throw Exception('Failed to delete iPhone stock: ${response.statusCode}');
    }
  } catch (e) {
    // Handle error
    throw Exception('Error deleting iPhone stock: $e');
  }
}
}
