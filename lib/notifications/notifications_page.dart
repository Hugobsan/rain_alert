import 'package:flutter/material.dart';
import 'package:rain_alert/shared/models/Notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Histórico de Notificações",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<List<NotificationModel>>(
          future: NotificationModel.getAll(), // Consulta diretamente o Model
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Erro ao carregar notificações.",
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Nenhuma notificação encontrada.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              );
            }

            final notifications = snapshot.data!;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  color: Color(int.parse(notification.colorPrimary)),
                  child: ListTile(
                    tileColor: Colors.grey[850],
                    leading: Icon(
                      IconData(
                        int.parse(notification.icon),
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Colors.white,
                    ),
                    title: Text(
                      notification.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Tipo: ${notification.type}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
