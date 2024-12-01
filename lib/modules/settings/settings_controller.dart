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

  /// Atualiza uma configuração e retorna uma mensagem de status
  Future<String> updateSetting(String key, dynamic value) async {
    try {
      if (currentSettings == null) {
        return 'Erro: Configurações não carregadas';
      }

      // Atualiza localmente
      currentSettings = currentSettings!.copyWith(
        tempUnit: key == 'temp_unit' ? value : currentSettings!.tempUnit,
        windUnit: key == 'wind_unit' ? value : currentSettings!.windUnit,
        pressureUnit: key == 'pressure_unit' ? value : currentSettings!.pressureUnit,
        predCitiesCount: key == 'pred_cities_count' ? value : currentSettings!.predCitiesCount,
        preferUpdateTime: key == 'prefer_update_time' ? value : currentSettings!.preferUpdateTime,
      );

      // Salva no banco
      await Settings.update(currentSettings!);

      notifyListeners();
      return 'Configuração atualizada com sucesso!';
    } catch (e) {
      return 'Erro ao salvar a configuração';
    }
  }
}
