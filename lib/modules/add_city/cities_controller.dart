import 'package:flutter/material.dart';
import '../../shared/services/weather_service.dart';
import 'package:provider/provider.dart';

class CitiesController extends ChangeNotifier {
  final WeatherService weatherService;
  final TextEditingController cityNameController = TextEditingController();
  Map<String, dynamic>? cityData;
  bool isLoading = false;

  CitiesController(BuildContext context)
      : weatherService = Provider.of<WeatherService>(context, listen: false);

  /// Função para buscar a cidade pelo nome
  Future<void> searchCity() async {
    final cityName = cityNameController.text.trim();
    if (cityName.isEmpty) return;

    isLoading = true;
    notifyListeners();

    cityData = await weatherService.getWeatherByCityName(cityName);

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    cityNameController.dispose();
    super.dispose();
  }
}
