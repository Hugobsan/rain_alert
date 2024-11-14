import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia o controle da splash para redirecionar após um tempo
    Provider.of<SplashController>(context, listen: false).initialize(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ou ícone do app
            Icon(Icons.cloud, size: 80.0, color: Colors.blue),
            SizedBox(height: 20),
            Text("Rain Alert", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Indicador de carregamento
          ],
        ),
      ),
    );
  }
}
