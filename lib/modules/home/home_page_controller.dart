// lib/modules/home/home_controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/services/geolocator_service.dart';
import '../../shared/services/weather_service.dart';

class HomeController {
  late GeolocatorService geolocatorService;
  late WeatherService weatherService;
  Map<String, double>? currentLocation;
  Map<String, dynamic>? _currentWeatherData;

  HomeController(BuildContext context) {
    geolocatorService = Provider.of<GeolocatorService>(context, listen: false);
    weatherService = Provider.of<WeatherService>(context, listen: false);
  }

  /// Carrega e armazena a localização atual
  Future<void> loadCurrentLocation() async {
    if (currentLocation == null) {
      currentLocation = await geolocatorService.getCurrentLocation();
    }
  }

  /// Carrega e armazena os dados do clima atual
  Future<Map<String, dynamic>?> loadWeatherData() async {
    if (_currentWeatherData == null) {
      if (currentLocation == null) {
        await loadCurrentLocation();
      }
      if (currentLocation != null) {
        _currentWeatherData = await weatherService.getWeather(
          currentLocation!['latitude']!,
          currentLocation!['longitude']!,
        );
      }
    }
    return _currentWeatherData;
  }

  /// Carrega a previsão do clima para os próximos dias
  Future<List<Map<String, dynamic>>> loadForecastData() async {
    if (currentLocation == null) {
      await loadCurrentLocation();
    }
    if (currentLocation != null) {
      return await weatherService.getForecast(
        latitude: currentLocation!['latitude']!,
        longitude: currentLocation!['longitude']!,
        count: 6,
      );
    }
    return [];
  }

  /// Retorna o nome da cidade
  Future<String> getCityName() async {
    final weatherData = await loadWeatherData();
    if (weatherData != null && weatherData.containsKey('name')) {
      return weatherData['name'];
    }
    return "Rain Alert";
  }

  /// Retorna se é dia ou noite
  bool isDaytime() {
    final int currentHour = DateTime.now().hour;
    return currentHour >= 6 && currentHour < 18;
  }

  /// Gradiente de fundo baseado no horário do dia
  LinearGradient getBackgroundGradient() {
    return isDaytime()
        ? const LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 115, 209),
              Color.fromARGB(255, 108, 166, 229),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [
              Color.fromARGB(255, 53, 67, 102),
              Color.fromARGB(255, 75, 102, 132),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  /// Cor do texto baseada no horário do dia
  Color getTextColor() {
    return Colors.white;
  }

  /// Converte um timestamp em um nome de dia legível
  String getDayName(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    switch (date.weekday) {
      case DateTime.monday:
        return 'Seg.';
      case DateTime.tuesday:
        return 'Ter.';
      case DateTime.wednesday:
        return 'Qua.';
      case DateTime.thursday:
        return 'Qui.';
      case DateTime.friday:
        return 'Sex.';
      case DateTime.saturday:
        return 'Sáb.';
      case DateTime.sunday:
        return 'Dom.';
      default:
        return '';
    }
  }

  /// Obtém o ícone do clima com base na descrição
  IconData getWeatherIcon(String description) {
    if (description.contains("chuva")) {
      return Icons.thunderstorm;
    } else if (description.contains("nublado")) {
      return Icons.cloud;
    } else if (description.contains("sol")) {
      return Icons.wb_sunny;
    } else {
      return Icons.wb_cloudy;
    }
  }

  /// Formata a descrição do clima
  String formatWeatherDescription(String description) {
    return description
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
