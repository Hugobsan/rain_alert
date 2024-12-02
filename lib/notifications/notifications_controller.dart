import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rain_alert/shared/models/Notification.dart';

class NotificationsController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<NotificationModel> get notifications => _notifications;

  // Método para carregar as notificações
  Future<void> loadNotifications() async {
    try {
      _notifications = await NotificationModel.getAll();
      notifyListeners(); // Garante que os listeners serão atualizados.
    } catch (e) {
      _notifications = []; // Define como vazio em caso de erro.
      notifyListeners(); // Garante que a interface reflete o estado atual.
      rethrow;
    }
  }

  // Método para adicionar uma notificação de exemplo
  Future<void> addExampleNotification() async {
    // Criando uma notificação de exemplo
    final notification = NotificationModel(
      type: 'Alerta de Chuva',
      cityId:
          1, // Usando um cityId genérico; você pode ajustar isso conforme necessário
      text: 'Alerta de chuva! Prepare-se para a chuva em breve.',
      colorPrimary: '0xFF2196F3', // Azul
      colorSecondary: '0xFFBBDEFB', // Azul claro para a cor secundária
      icon: 'thunderstorm', // Nome do ícone
    );

    // Salvando a notificação no banco de dados
    await notification.save(); // Método para salvar no banco de dados

    // Atualizando a lista de notificações
    _notifications.add(notification);
    notifyListeners(); // Notifica que as notificações foram atualizadas

    // Enviando uma notificação local
    await showNotification();
  }

  // Método para exibir a notificação local
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
      0, // ID da notificação
      'Alerta de Chuva', // Título
      'Está chovendo na sua área', // Corpo da mensagem
      platformChannelSpecifics,
      payload: 'item x', // Payload (opcional)
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
