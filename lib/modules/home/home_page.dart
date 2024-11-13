import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/services/geolocator_service.dart';
import '../../shared/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _loadWeatherData(BuildContext context) async {
    final geolocatorService = Provider.of<GeolocatorService>(context, listen: false);
    final weatherService = Provider.of<WeatherService>(context, listen: false);

    Position? position = await geolocatorService.getCurrentLocation();

    if (position != null) {
      return await weatherService.getWeather(position.latitude, position.longitude);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/addCity');
          },
        ),
        title: FutureBuilder<Map<String, dynamic>?>(
          future: _loadWeatherData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Carregando...");
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text("Erro");
            } else {
              final weatherData = snapshot.data!;
              final cityName = weatherData['name'];
              return Text(cityName); // Exibe o nome da cidade no centro do AppBar
            }
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'login') {
                Navigator.of(context).pushNamed('/login');
              } else if (value == 'settings') {
                Navigator.of(context).pushNamed('/settings');
              } else if (value == 'notifications') {
                Navigator.of(context).pushNamed('/notifications');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'login',
                child: Text('Login'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Configurações'),
              ),
              const PopupMenuItem(
                value: 'notifications',
                child: Text('Histórico de Notificações'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _loadWeatherData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Erro ao carregar dados do clima."));
          } else {
            final weatherData = snapshot.data!;
            final cityName = weatherData['name'];
            final temperature = weatherData['main']['temp'];
            final description = weatherData['weather'][0]['description'];
            final minTemp = weatherData['main']['temp_min'];
            final maxTemp = weatherData['main']['temp_max'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$cityName",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${temperature.toStringAsFixed(1)}°C",
                    style: const TextStyle(fontSize: 32),
                  ),
                  Text(
                    "Clima: $description",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Mínima: ${minTemp.toStringAsFixed(1)}°C / Máxima: ${maxTemp.toStringAsFixed(1)}°C",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
