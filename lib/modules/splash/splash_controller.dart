import 'dart:async';
import 'package:flutter/material.dart';

class SplashController {
  void initialize(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      // Após 3 segundos, redireciona para a tela principal
      Navigator.of(context).pushReplacementNamed('/home'); // Ajuste a rota da tela principal
    });
  }
}
