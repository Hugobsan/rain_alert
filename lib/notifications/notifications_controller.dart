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
}
