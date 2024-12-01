import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cities_controller.dart';
import '../../shared/models/city.dart';

class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CitiesController>(context, listen: false);

    // Carrega a lista de cidades salvas ao construir a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshSavedCities();
    });
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Gerenciar cidades",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.cityNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Inserir local',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                onSubmitted: (_) => controller.searchCity(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.searchCity,
                child: const Text('Buscar cidade'),
              ),
              const SizedBox(height: 16),

              // Card da cidade buscada
              Consumer<CitiesController>(
                builder: (context, controller, _) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.cityData == null) {
                    return const Center(
                      child: Text(
                        "Nenhuma cidade encontrada.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return FutureBuilder<bool>(
                    future:
                        controller.isCitySaved(controller.cityData!['name']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      final isSaved = snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            color: Colors.blueAccent,
                            child: ListTile(
                              leading: const Icon(
                                Icons.location_city,
                                color: Colors.white,
                              ),
                              title: Text(
                                controller.cityData!['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Temperatura: ${controller.cityData!['main']['temp']}°C",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: isSaved
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.check,
                                          color: Colors.white),
                                      onPressed: controller.saveCity,
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Lista de cidades salvas
              Expanded(
                child: Consumer<CitiesController>(
                  builder: (context, controller, _) {
                    if (controller.savedCities.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma cidade salva.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: controller.savedCities.length,
                      itemBuilder: (context, index) {
                        final city = controller.savedCities[index];
                        return Card(
                          color: Colors.grey[800],
                          child: ListTile(
                            leading: const Icon(
                              Icons.location_city,
                              color: Colors.white,
                            ),
                            title: Text(
                              city.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "Lat: ${city.latitude}, Lon: ${city.longitude}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                await controller.deleteCity(city.id!);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
