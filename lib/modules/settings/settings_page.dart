import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SettingsController>(context);

    if (controller.currentSettings == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    final settings = controller.currentSettings!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Unidade de Temperatura
            DropdownButtonFormField<String>(
              value: settings.tempUnit,
              decoration: InputDecoration(
                labelText: 'Unidade de Temperatura',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: Colors.grey[900],
              items: const [
                DropdownMenuItem(
                  value: 'C',
                  child: Text('Celsius (°C)', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'F',
                  child: Text('Fahrenheit (°F)', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'K',
                  child: Text('Kelvin (K)', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) async {
                if (value != null) {
                  final message = await controller.updateSetting('temp_unit', value);

                  // Exibe SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Unidade de Velocidade do Vento
            DropdownButtonFormField<String>(
              value: settings.windUnit,
              decoration: InputDecoration(
                labelText: 'Unidade de Velocidade do Vento',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: Colors.grey[900],
              items: const [
                DropdownMenuItem(
                  value: 'km/h',
                  child: Text('km/h', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'm/s',
                  child: Text('m/s', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) async {
                if (value != null) {
                  final message = await controller.updateSetting('wind_unit', value);

                  // Exibe SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Unidade de Pressão Atmosférica
            DropdownButtonFormField<String>(
              value: settings.pressureUnit,
              decoration: InputDecoration(
                labelText: 'Unidade de Pressão Atmosférica',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: Colors.grey[900],
              items: const [
                DropdownMenuItem(
                  value: 'hPa',
                  child: Text('hPa', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'mmHg',
                  child: Text('mmHg', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) async {
                if (value != null) {
                  final message = await controller.updateSetting('pressure_unit', value);

                  // Exibe SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Quantidade de Cidades para Predição
            TextFormField(
              initialValue: settings.predCitiesCount.toString(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Quantidade de Cidades para Predição',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) async {
                final intValue = int.tryParse(value);
                if (intValue != null && intValue >= 1 && intValue <= 10) {
                  final message = await controller.updateSetting('pred_cities_count', intValue);

                  // Exibe SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Melhor Horário para Atualização
            TextFormField(
              initialValue: settings.preferUpdateTime,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Melhor Horário para Atualização',
                labelStyle: const TextStyle(color: Colors.white),
                hintText: 'HH:mm',
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                  hour: int.parse(settings.preferUpdateTime.split(':')[0]),
                  minute: int.parse(settings.preferUpdateTime.split(':')[1]),
                  ),
                  builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      surface: Colors.black,
                      onSurface: Colors.white,
                    ),
                    dialogBackgroundColor: Colors.black,
                    timePickerTheme: TimePickerThemeData(
                      dialHandColor: Colors.white,
                      dialBackgroundColor: Colors.grey[900],
                      hourMinuteTextColor: Colors.white,
                      hourMinuteColor: Colors.grey[900],
                      hourMinuteShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.white),
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      ),
                    ),
                    ),
                    child: child!,
                  );
                  },
                );
                if (time != null) {
                  final formattedTime =
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  final message =
                      await controller.updateSetting('prefer_update_time', formattedTime);

                  // Exibe SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
