import 'package:flutter/material.dart';
import '../../shared/services/weather_service.dart';
import 'package:provider/provider.dart';
import '../../shared/models/city.dart';

class CitiesController extends ChangeNotifier {
  final WeatherService weatherService;
  final TextEditingController cityNameController = TextEditingController();
  Map<String, dynamic>? cityData;
  bool isLoading = false;
  List<City> savedCities = [];

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

  /// Função para salvar a cidade no banco
  Future<void> saveCity() async {
    if (cityData == null) return;

    final city = City(
      name: cityData!['name'],
      latitude: cityData!['coord']['lat'],
      longitude: cityData!['coord']['lon'],
    );

    await City.insert(city);

    cityData = null;

    await refreshSavedCities();
  }

  /// Função para excluir a cidade
  Future<void> deleteCity(int cityId) async {
    await City.delete(cityId);
    await refreshSavedCities();
  }

  /// Função para verificar se a cidade já está salva
  Future<bool> isCitySaved(String cityName) async {
    final cities = await City.getAll();
    return cities.any((city) => city.name == cityName);
  }

  /// Função para listar todas as cidades salvas
  Future<List<City>> getSavedCities() async {
    return await City.getAll();
  }

  /// Notifica as alterações na lista de cidades salvas
  Future<void> refreshSavedCities() async {
    savedCities = await City.getAll();
    notifyListeners();
  }

  @override
  void dispose() {
    cityNameController.dispose();
    super.dispose();
  }
}
