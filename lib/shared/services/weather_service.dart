import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String? _apiKey = dotenv.env['OPENWEATHER_API_KEY'];
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Obtém informações climáticas com base na latitude e longitude
  Future<Map<String, dynamic>?> getWeather(
      double latitude, double longitude, String unit) async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=$unit&lang=pt_br',
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

  /// Obtém previsão de tempo com base na latitude e longitude
  Future<List<Map<String, dynamic>>> getForecast({
    required double latitude,
    required double longitude,
    int count = 4,
    String unit = 'metric',
  }) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=$unit&lang=pt_br',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List forecasts = data['list'];

        // Agrupando previsões por dia
        Map<String, Map<String, dynamic>> dailyForecasts = {};

        for (var forecast in forecasts) {
          final date =
              DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          final dayKey = "${date.year}-${date.month}-${date.day}";

          if (!dailyForecasts.containsKey(dayKey)) {
            dailyForecasts[dayKey] = {
              'dt': forecast['dt'],
              'temp_min': forecast['main']['temp_min'],
              'temp_max': forecast['main']['temp_max'],
              'weather': forecast['weather'][0]['description'],
            };
          } else {
            // Atualiza as temperaturas mínimas e máximas
            dailyForecasts[dayKey]?['temp_min'] = (forecast['main']
                        ['temp_min'] <
                    dailyForecasts[dayKey]?['temp_min'])
                ? forecast['main']['temp_min']
                : dailyForecasts[dayKey]?['temp_min'];
            dailyForecasts[dayKey]?['temp_max'] = (forecast['main']
                        ['temp_max'] >
                    dailyForecasts[dayKey]?['temp_max'])
                ? forecast['main']['temp_max']
                : dailyForecasts[dayKey]?['temp_max'];
          }
        }

        // Retorna apenas os primeiros dias
        return dailyForecasts.values
            .take(count)
            .toList()
            .cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao carregar previsões');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao carregar previsões');
    }
  }

  /// Obtém informações climáticas com base no nome da cidade
  Future<Map<String, dynamic>?> getWeatherByCityName(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric&lang=pt_br',
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
