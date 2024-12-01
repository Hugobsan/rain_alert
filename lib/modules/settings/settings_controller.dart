import 'package:flutter/material.dart';
import '../../shared/models/settings.dart';

class SettingsController extends ChangeNotifier {
  Settings? currentSettings;

  SettingsController() {
    loadSettings();
  }

  /// Carrega as configurações existentes
  Future<void> loadSettings() async {
    currentSettings = await Settings.getSettings();
    notifyListeners();
  }

  /// Atualiza uma configuração e salva no banco
  Future<void> updateSetting(String key, dynamic value) async {
    if (currentSettings == null) return;

    // Atualiza o valor localmente
    switch (key) {
      case 'temp_unit':
        currentSettings = currentSettings!.copyWith(tempUnit: value);
        break;
      case 'wind_unit':
        currentSettings = currentSettings!.copyWith(windUnit: value);
        break;
      case 'pressure_unit':
        currentSettings = currentSettings!.copyWith(pressureUnit: value);
        break;
      case 'pred_cities_count':
        currentSettings = currentSettings!.copyWith(predCitiesCount: value);
        break;
      case 'prefer_update_time':
        currentSettings = currentSettings!.copyWith(preferUpdateTime: value);
        break;
    }

    // Salva no banco
    await Settings.update(currentSettings!);
    notifyListeners();
  }
}
