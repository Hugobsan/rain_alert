// lib/app/app_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rain_alert/modules/home/home_page.dart';
import 'package:rain_alert/modules/home/home_page_controller.dart';
import 'package:rain_alert/modules/splash/splash_controller.dart';
import 'package:rain_alert/modules/splash/splash_page.dart';
import 'package:rain_alert/shared/services/geolocator_service.dart';
import 'package:rain_alert/shared/services/weather_service.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SplashController()),
        Provider(create: (_) => GeolocatorService()),
        Provider(create: (_) => WeatherService()),
        // Controller será inicializado automaticamente
      ],
      child: MaterialApp(
        title: 'Rain Alert',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashPage(),
          '/home': (context) => Provider(
                create: (context) => HomeController(context),
                child: HomePage(),
              ),
        },
      ),
    );
  }
}
