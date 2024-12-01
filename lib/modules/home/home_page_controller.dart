// lib/modules/home/home_controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rain_alert/shared/models/City.dart';
import 'package:rain_alert/shared/models/Settings.dart';
import '../../shared/services/geolocator_service.dart';
import '../../shared/services/weather_service.dart';

class HomeController extends ChangeNotifier {
  late GeolocatorService geolocatorService;
  late WeatherService weatherService;
  Settings? currentSettings;
  Map<String, double>? currentLocation;
  Map<String, dynamic>? _currentWeatherData;
  List<City> _savedCities = [];

  List<City> get savedCities => _savedCities;

  HomeController(BuildContext context) {
    geolocatorService = Provider.of<GeolocatorService>(context, listen: false);
    weatherService = Provider.of<WeatherService>(context, listen: false);
  }

  /// Carrega as configurações
  Future<void> loadSettings() async {
    currentSettings = await Settings.getSettings();
  }

  /// Carrega e armazena a localização atual
  Future<void> loadCurrentLocation() async {
    if (currentLocation == null) {
      currentLocation = await geolocatorService.getCurrentLocation();
    }
  }

  /// Carrega as cidades salvas do banco de dados
  Future<void> loadSavedCities() async {
    final cities = await City.getAll();
    _savedCities = cities;
    notifyListeners(); // Notifica a interface para atualizar os dados
  }

  /// Carrega e armazena os dados do clima atual
  Future<Map<String, dynamic>?> loadWeatherData({City? city}) async {
    if (city != null) {
      // Dados baseados na cidade selecionada
      _currentWeatherData = await weatherService.getWeather(
        city.latitude,
        city.longitude,
        currentSettings?.getFormattedTempUnit()['apiUnit'] ?? 'metric',
      );
    } else {
      // Dados baseados na localização atual
      if (_currentWeatherData == null) {
        if (currentLocation == null) {
          await loadCurrentLocation();
        }
        if (currentLocation != null) {
          _currentWeatherData = await weatherService.getWeather(
            currentLocation!['latitude']!,
            currentLocation!['longitude']!,
            currentSettings?.getFormattedTempUnit()['apiUnit'] ?? 'metric',
          );
        }
      }
    }
    return _currentWeatherData;
  }

  /// Carrega a previsão do clima para os próximos dias
  Future<List<Map<String, dynamic>>> loadForecastData({City? city}) async {
    if (city != null) {
      // Previsão para a cidade selecionada
      final count = currentSettings?.predCitiesCount ?? 6;
      final unit =
          currentSettings?.getFormattedTempUnit()['apiUnit'] ?? 'metric';
      return await weatherService.getForecast(
        latitude: city.latitude,
        longitude: city.longitude,
        count: count,
        unit: unit,
      );
    } else {
      // Previsão baseada na localização atual
      if (currentLocation == null) {
        await loadCurrentLocation();
      }
      if (currentLocation != null) {
        final count = currentSettings?.predCitiesCount ?? 6;
        final unit =
            currentSettings?.getFormattedTempUnit()['apiUnit'] ?? 'metric';
        return await weatherService.getForecast(
          latitude: currentLocation!['latitude']!,
          longitude: currentLocation!['longitude']!,
          count: count,
          unit: unit,
        );
      }
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
