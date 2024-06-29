import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodApiService {
  final String _appId = '8613622b';
  final String _appKey = 'ba2b4058d56d7c0a6d6f89618219def0';

  Future<List<FoodItem>> fetchFoodItems(String query) async {
    final String apiUrl =
        'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$_appId&app_key=$_appKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['hints'];
      print(data); // Gelen verileri kontrol etmek için yazdır
      List<FoodItem> foodItems = data.map((item) {
        final food = item['food'];
        return FoodItem.fromJson(food);
      }).toList();
      return foodItems;
    } else {
      throw Exception('Failed to load food items');
    }
  }
}

class FoodItem {
  final String name;
  final double calories;
  final String? imageUrl;
  final double? amount;

  FoodItem({
    required this.name,
    required this.calories,
    this.imageUrl,
    this.amount,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['label'],
      calories: json['nutrients']['ENERC_KCAL'] != null
          ? (json['nutrients']['ENERC_KCAL'] as num).toDouble()
          : 0.0,
      imageUrl: json['image'],
      amount: json['amount'] != null ? json['amount'].toDouble() : null,
    );
  }

  FoodItem copyWithAmount(double newAmount) {
    return FoodItem(
      name: this.name,
      calories: this.calories * newAmount / 100,
      imageUrl: this.imageUrl,
      amount: newAmount,
    );
  }
}
