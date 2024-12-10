// lib/app/app_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rain_alert/modules/add_city/cities_controller.dart';
import 'package:rain_alert/modules/add_city/cities_page.dart';
import 'package:rain_alert/modules/auth/login_register_page.dart';
import 'package:rain_alert/modules/home/home_page.dart';
import 'package:rain_alert/modules/home/home_page_controller.dart';
import 'package:rain_alert/modules/settings/settings_controller.dart';
import 'package:rain_alert/modules/settings/settings_page.dart';
import 'package:rain_alert/modules/splash/splash_controller.dart';
import 'package:rain_alert/modules/splash/splash_page.dart';
import 'package:rain_alert/notifications/notifications_controller.dart';
import 'package:rain_alert/notifications/notifications_page.dart';
import 'package:rain_alert/shared/services/auth_service.dart';
import 'package:rain_alert/shared/services/geolocator_service.dart';
import 'package:rain_alert/shared/services/weather_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SplashController()),
        Provider(create: (_) => GeolocatorService()),
        Provider(create: (_) => WeatherService()),
        Provider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => NotificationsController()),

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
          '/addCity': (context) => ChangeNotifierProvider(
                create: (context) => CitiesController(context),
                child: CitiesPage(),
              ),
          '/home': (context) => ChangeNotifierProvider(
                create: (context) => HomeController(context),
                child: HomePage(),
              ),
          '/settings': (context) => SettingsPage(),
          '/notifications': (context) => ChangeNotifierProvider(
                create: (context) => NotificationsController(),
                child: const NotificationsPage(),
              ),
          '/login': (context) => const LoginPage(),
        },
      ),
    );
  }
}

class NotificationsController2 with ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inicialização do plugin
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Enviar notificação local
  Future<void> sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id', // ID do canal
      'Rain Alert', // Nome do canal
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
