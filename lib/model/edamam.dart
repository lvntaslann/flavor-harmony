import 'package:flutter_dotenv/flutter_dotenv.dart';

class Edamam {
  static String apiKey = dotenv.env['EDAMAM_API_KEY'] ?? '';
  static String appId = dotenv.env['EDAMAM_APP_ID'] ?? '';
  static String baseUrl = dotenv.env['EDAMAM_BASE_URL'] ?? '';
}