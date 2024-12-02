import 'dart:async';
import 'package:flutter/material.dart';

class SplashController {
  void initialize(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }
}
