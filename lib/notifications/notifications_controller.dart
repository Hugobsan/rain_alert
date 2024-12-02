import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rain_alert/shared/models/Notification.dart';

class NotificationsController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<NotificationModel> get notifications => _notifications;

  Future<void> loadNotifications() async {
    try {
      _notifications = await NotificationModel.getAll();
      notifyListeners();
    } catch (e) {
      _notifications = [];
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addExampleNotification() async {
    final notification = NotificationModel(
      type: 'Alerta de Chuva',
      cityId: 1,
      text: 'Alerta de chuva! Prepare-se para a chuva em breve.',
      colorPrimary: '0xFF2196F3',
      colorSecondary: '0xFFBBDEFB',
      icon: 'thunderstorm',
    );

    await notification.save(); 

    _notifications.add(notification);
    notifyListeners();

    await showNotification();
  }

  Future<void> showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_notification',
    );

    var platformChannelSpecifics = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Alerta de Chuva',
      'Está chovendo na sua área, prepare o guarda-chuva!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  IconData getWeatherIcon(String icon) {
    switch (icon) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'drizzle':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }
}
