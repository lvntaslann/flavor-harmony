import 'package:http/http.dart' as http;
import 'dart:convert';

class EdamamApiService {
  static Future<List<dynamic>> searchFoods(String query) async {
    String apiKey =
        'ba2b4058d56d7c0a6d6f89618219def0'; // Edamam API anahtarınızı buraya girin
    String appId = '8613622b'; // Edamam API uygulama kimliğinizi buraya girin

    String baseUrl = 'https://api.edamam.com/api/food-database/v2/';
    String url =
        '$baseUrl/parser?ingr=$query&app_id=$appId&app_key=$apiKey'; // İstek URL'si oluşturma

    try {
      // HTTP GET isteği gönderme
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Başarılı yanıt durumunda verileri işleme
        var data = json.decode(response.body);
        return data['parsed'];
      } else {
        // Hata durumunda hata mesajını yazdırma
        print('Hata: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Hata durumunda hata mesajını yazdırma
      print('Hata: $error');
      return [];
    }
  }
}
