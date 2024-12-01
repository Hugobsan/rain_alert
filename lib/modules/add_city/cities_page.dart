import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cities_controller.dart';

class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CitiesController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Gerenciar cidades",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.cityNameController,
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
              Expanded(
                child: Consumer<CitiesController>(
                  builder: (context, controller, _) {
                    if (controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.cityData == null) {
                      return const Center(
                        child: Text("Nenhuma cidade encontrada."),
                      );
                    }
                    return Card(
                      color: Colors.blueAccent,
                      child: ListTile(
                        leading: const Icon(Icons.location_city,
                            color: Colors.white),
                        title: Text(
                          controller.cityData!['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "Temperatura: ${controller.cityData!['main']['temp']}°C",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
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
