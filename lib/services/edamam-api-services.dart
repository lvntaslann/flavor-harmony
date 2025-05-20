import 'dart:convert';
import 'package:flavor_harmony_app/model/edamam.dart';
import 'package:flavor_harmony_app/model/food.dart';
import 'package:http/http.dart' as http;

class EdamamApi {
  final String _apiKey = Edamam.apiKey;
  final String _appId = Edamam.appId;
  final String _baseUrl = Edamam.baseUrl;

  /// Search foods using simple parser endpoint
  Future<List<dynamic>> searchFoods(String query) async {
    final String url = '$_baseUrl/parser?ingr=$query&app_id=$_appId&app_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['parsed'] ?? [];
      } else {
        print('API Error (searchFoods): ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Exception (searchFoods): $error');
      return [];
    }
  }

  /// Fetch structured list of FoodItem objects
  Future<List<FoodItem>> fetchFoodItems(String query) async {
    final String url = '$_baseUrl/parser?ingr=$query&app_id=$_appId&app_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['hints'] ?? [];
        return data.map((item) {
          final food = item['food'];
          return FoodItem.fromJson(food);
        }).toList();
      } else {
        print('API Error (fetchFoodItems): ${response.statusCode}');
        throw Exception('Failed to load food items');
      }
    } catch (error) {
      print('Exception (fetchFoodItems): $error');
      throw Exception('Error fetching food items: $error');
    }
  }
}
