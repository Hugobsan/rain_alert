import 'package:flutter/material.dart';
import 'package:rain_alert/shared/models/Notification.dart';

class NotificationsController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

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
      icon: '0xe2c9', // Ícone de nuvem com gotas (em hexadecimal)
    );

    // Salvando a notificação no banco de dados
    await notification.save(); // Método para salvar no banco de dados

    // Atualizando a lista de notificações
    _notifications.add(notification);
    notifyListeners(); // Notifica que as notificações foram atualizadas
  }
}
