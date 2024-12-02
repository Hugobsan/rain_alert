import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rain_alert/modules/home/home_page_controller.dart';
import 'package:rain_alert/shared/models/City.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    final homeController = Provider.of<HomeController>(context, listen: false);
    homeController.loadSettings();
    homeController.loadSavedCities();
    homeController.loadWeatherData();
    homeController.loadForecastData();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final isDaytime = homeController.isDaytime();
    final textColor = homeController.getTextColor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDaytime
            ? const Color.fromARGB(255, 2, 115, 209)
            : const Color.fromARGB(255, 53, 67, 102),
        leading: IconButton(
          icon: Icon(Icons.add, color: textColor),
          onPressed: () {
            Navigator.of(context).pushNamed('/addCity');
          },
        ),
        title: DropdownButton<City>(
          value: _selectedCity,
          dropdownColor: isDaytime
              ? const Color.fromARGB(255, 2, 115, 209)
              : const Color.fromARGB(255, 53, 67, 102),
          hint: Text(
            homeController.savedCities.isNotEmpty
                ? "Selecione uma cidade"
                : "Carregando cidades...",
            style: TextStyle(color: textColor),
          ),
          onChanged: (City? city) {
            setState(() {
              _selectedCity = city;
            });
            homeController.loadWeatherData(city: city);
            homeController.loadForecastData(city: city);
          },
          items: homeController.savedCities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(
                city.name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textColor),
            color: isDaytime
                ? const Color.fromARGB(255, 2, 115, 209)
                : const Color.fromARGB(255, 53, 67, 102),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).pushNamed('/settings');
              } else if (value == 'notifications') {
                Navigator.of(context).pushNamed('/notifications');
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'notifications',
                child: Text(
                  'Notificações',
                  style: TextStyle(color: textColor),
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text(
                  'Configurações',
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          homeController.loadSavedCities();
          homeController.loadWeatherData(city: _selectedCity);
          homeController.loadForecastData(city: _selectedCity);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              gradient: homeController.getBackgroundGradient(),
            ),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                FutureBuilder<Map<String, dynamic>?>(
                  future: homeController.loadWeatherData(city: _selectedCity),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Erro ao carregar dados do clima.",
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      );
                    } else {
                      final weatherData = snapshot.data!;
                      final description =
                          homeController.formatWeatherDescription(
                              weatherData['weather'][0]['description']);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${weatherData['main']['temp'].toStringAsFixed(1)}${homeController.currentSettings?.getFormattedTempUnit()['unit'] ?? '°C'}",
                              style: TextStyle(fontSize: 75, color: textColor),
                            ),
                            Icon(
                              homeController.getWeatherIcon(description),
                              size: 80,
                              color: textColor,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              style: TextStyle(fontSize: 18, color: textColor),
                            ),
                            Text(
                              "Mínima: ${weatherData['main']['temp_min'].toStringAsFixed(1)}${homeController.currentSettings?.getFormattedTempUnit()['unit'] ?? '°C'} / Máxima: ${weatherData['main']['temp_max'].toStringAsFixed(1)}${homeController.currentSettings?.getFormattedTempUnit()['unit'] ?? '°C'}",
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: homeController.loadForecastData(city: _selectedCity),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: forecastData.length,
                        itemBuilder: (context, index) {
                          final dayForecast = forecastData[index];
                          return ListTile(
                            leading: Icon(
                              homeController
                                  .getWeatherIcon(dayForecast['weather']),
                              color: textColor,
                            ),
                            title: Text(
                              "${homeController.getDayName(dayForecast['dt'])} ${homeController.formatWeatherDescription(dayForecast['weather'])}",
                              style: TextStyle(color: textColor),
                            ),
                            trailing: Text(
                              "${dayForecast['temp_max'].toStringAsFixed(1)}${homeController.currentSettings?.getFormattedTempUnit()['unit'] ?? '°C'} / ${dayForecast['temp_min'].toStringAsFixed(1)}${homeController.currentSettings?.getFormattedTempUnit()['unit'] ?? '°C'}",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
