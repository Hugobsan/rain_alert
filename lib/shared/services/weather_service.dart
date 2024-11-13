import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String? _apiKey = dotenv.env['OPENWEATHER_API_KEY'];
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Obtém informações climáticas com base na latitude e longitude
  Future<Map<String, dynamic>?> getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric&lang=pt_br',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Erro na requisição: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return null;
    }
  }
}
