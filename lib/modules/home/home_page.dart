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

  Future<List<Map<String, dynamic>>> _loadForecastData(
      BuildContext context) async {
    final geolocatorService =
        Provider.of<GeolocatorService>(context, listen: false);
    final weatherService = Provider.of<WeatherService>(context, listen: false);

    Position? position = await geolocatorService.getCurrentLocation();

    if (position != null) {
      return await weatherService.getForecast(
          latitude: position.latitude, longitude: position.longitude, count: 6);
    } else {
      return [];
    }
  }

  /// Função para verificar se é dia ou noite
  bool _isDaytime() {
    final int currentHour = DateTime.now().hour;
    return currentHour >= 6 && currentHour < 18;
  }

  /// Gradiente de fundo baseado no horário do dia
  LinearGradient _getBackgroundGradient() {
    return _isDaytime()
        ? LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : LinearGradient(
            colors: [
              const Color.fromARGB(255, 53, 67, 102),
              const Color.fromARGB(255, 75, 102, 132),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  /// Cor do texto baseada no horário do dia
  Color _getTextColor() {
    return _isDaytime() ? Colors.black : Colors.white;
  }

  // Converte um timestamp em um nome de dia legível
  String _getDayName(int timestamp) {
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

  IconData _getWeatherIcon(String description) {
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

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isDaytime()
            ? Colors.lightBlueAccent
            : const Color.fromARGB(255, 53, 67, 102),
        leading: IconButton(
          icon: Icon(Icons.add, color: _getTextColor()), // Removido o 'const'
          onPressed: () {
            Navigator.of(context).pushNamed('/addCity');
          },
        ),
        title: Text(
          'Rain Alert',
          style: TextStyle(color: _getTextColor()), // Removido o 'const'
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: _getTextColor()),
            color: _isDaytime()
                ? Colors.lightBlueAccent
                : const Color.fromARGB(
                    255, 53, 67, 102), // Cor de fundo dinâmica
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
                child: Text(
                  'Login',
                  style: TextStyle(color: _getTextColor()),
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text(
                  'Configurações',
                  style: TextStyle(color: _getTextColor()),
                ),
              ),
              PopupMenuItem(
                value: 'notifications',
                child: Text(
                  'Histórico de Notificações',
                  style: TextStyle(color: _getTextColor()),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: _getBackgroundGradient(),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _loadWeatherData(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Center(
                      child: Text(
                        "Erro ao carregar dados do clima.",
                        style: TextStyle(color: textColor),
                      ),
                    );
                  } else {
                    final weatherData = snapshot.data!;
                    final temperature = weatherData['main']['temp'];
                    final minTemp = weatherData['main']['temp_min'];
                    final maxTemp = weatherData['main']['temp_max'];
                    final description =
                        weatherData['weather'][0]['description'];
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${temperature.toStringAsFixed(1)}°C",
                            style: TextStyle(fontSize: 75, color: textColor),
                          ),
                          Icon(
                            _getWeatherIcon(description
                                .toLowerCase()), // Ícone de clima com base na descrição
                            size: 80,
                            color: textColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            description,
                            style: TextStyle(fontSize: 18, color: textColor),
                          ),
                          Text(
                            "Mínima: ${minTemp.toStringAsFixed(1)}° / Máxima: ${maxTemp.toStringAsFixed(1)}°", // Temperaturas mínima e máxima
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 75,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      "Previsão para os próximos 6 dias",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _loadForecastData(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return Center(
                            child: Text(
                              "Erro ao carregar previsão.",
                              style: TextStyle(color: textColor),
                            ),
                          );
                        } else {
                          final forecastData = snapshot.data!;
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: forecastData.length,
                                  itemBuilder: (context, index) {
                                    final dayForecast = forecastData[index];
                                    final dayName =
                                        _getDayName(dayForecast['dt']);
                                    final minTemp = dayForecast['temp_min'];
                                    final maxTemp = dayForecast['temp_max'];
                                    final description = dayForecast['weather'];
                                    final weatherIcon = _getWeatherIcon(
                                        description.toLowerCase());

                                    return ListTile(
                                      leading:
                                          Icon(weatherIcon, color: textColor),
                                      title: Text(
                                        "$dayName $description",
                                        style: TextStyle(color: textColor),
                                      ),
                                      trailing: Text(
                                        "${maxTemp.toStringAsFixed(1)}° / ${minTemp.toStringAsFixed(1)}°",
                                        style: TextStyle(
                                            color: textColor, fontSize: 16),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
