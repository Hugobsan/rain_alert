import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/services/geolocator_service.dart';
import '../../shared/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>?> _loadWeatherData(BuildContext context) async {
    final geolocatorService =
        Provider.of<GeolocatorService>(context, listen: false);
    final weatherService = Provider.of<WeatherService>(context, listen: false);

    Position? position = await geolocatorService.getCurrentLocation();

    if (position != null) {
      return await weatherService.getWeather(
          position.latitude, position.longitude);
    } else {
      return null;
    }
  }

  // Define o gradiente baseado no horário do dia
  LinearGradient _getBackgroundGradient() {
    final int currentHour = DateTime.now().hour;
    final isDaytime = currentHour >= 6 && currentHour < 18;

    return isDaytime
        ? LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : LinearGradient(
            colors: [
              const Color.fromARGB(255, 53, 67, 102),
              const Color.fromARGB(255, 75, 102, 132)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  // Retorna a primeira cor do gradiente, para o AppBar
  Color _getAppBarColor() {
    final int currentHour = DateTime.now().hour;
    final isDaytime = currentHour >= 6 && currentHour < 18;

    return isDaytime ? Colors.lightBlueAccent : const Color.fromARGB(255, 53, 67, 102);
  }

  // Define a cor do texto e dos ícones com base no horário do dia
  Color _getTextColor() {
    final int currentHour = DateTime.now().hour;
    final isDaytime = currentHour >= 6 && currentHour < 18;

    return isDaytime ? Colors.black : Colors.white;
  }

  // Define o ícone de acordo com o tipo de clima
  IconData _getWeatherIcon(String description) {
    if (description.contains("chuva")) {
      return Icons.thunderstorm; // Ícone de chuva
    } else if (description.contains("nublado")) {
      return Icons.cloud; // Ícone de nuvens
    } else if (description.contains("sol")) {
      return Icons.wb_sunny; // Ícone de sol
    } else if (description.contains("nev")) {
      return Icons.ac_unit; // Ícone de neve
    } else {
      return Icons.wb_cloudy; // Ícone genérico para clima
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(); // Obtemos a cor do texto e dos ícones

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getAppBarColor(),
        iconTheme: IconThemeData(color: textColor), // Define a cor dos ícones do AppBar
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
              return Text("Carregando...", style: TextStyle(color: textColor));
            } else if (snapshot.hasError || snapshot.data == null) {
              return Text("Erro", style: TextStyle(color: textColor));
            } else {
              final weatherData = snapshot.data!;
              final cityName = weatherData['name'];
              return Text(cityName, style: TextStyle(color: textColor));
            }
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textColor), // Define a cor do ícone do menu
            color: _getAppBarColor(),
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
              PopupMenuItem(
                value: 'login',
                child: Text('Login', style: TextStyle(color: textColor)),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text('Configurações', style: TextStyle(color: textColor)),
              ),
              PopupMenuItem(
                value: 'notifications',
                child: Text('Histórico de Notificações', style: TextStyle(color: textColor)),
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
            return Center(
                child: Text("Erro ao carregar dados do clima.", style: TextStyle(color: textColor)));
          } else {
            final weatherData = snapshot.data!;
            final temperature = weatherData['main']['temp'];
            final description = weatherData['weather'][0]['description']
                .split(' ')
                .map((word) => word[0].toUpperCase() + word.substring(1))
                .join(' ');
            final minTemp = weatherData['main']['temp_min'];
            final maxTemp = weatherData['main']['temp_max'];
            final gradient = _getBackgroundGradient();
            final weatherIcon = _getWeatherIcon(description.toLowerCase());

            return Container(
              decoration: BoxDecoration(gradient: gradient),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${temperature.toStringAsFixed(1)}°C",
                      style: TextStyle(fontSize: 75, color: textColor),
                    ),
                    Icon(
                      weatherIcon,
                      size: 80,
                      color: textColor,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "$description ${minTemp.toStringAsFixed(1)}°/${maxTemp.toStringAsFixed(1)}°",
                      style: TextStyle(fontSize: 18, color: textColor),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
