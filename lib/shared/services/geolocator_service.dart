import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  /// Verifica permissões e obtém a localização atual do usuário.
  Future<Map<String, double>?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Serviço de localização desativado.");
      return null;
    }

    // Verifica a permissão de localização
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Permissão de localização negada.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Permissão de localização permanentemente negada.");
      return null;
    }

    // Permissões concedidas, obtém a posição atual
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }
}
