import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoordenadasScreen(),
    );
  }
}

class CoordenadasScreen extends StatefulWidget {
  @override
  _CoordenadasScreenState createState() => _CoordenadasScreenState();
}

class _CoordenadasScreenState extends State<CoordenadasScreen> {
  final List<Map<String, double>> coordenadas = [];
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void adicionarCoordenada() {
    final double? lat = double.tryParse(latitudeController.text);
    final double? lon = double.tryParse(longitudeController.text);

    if (lat != null && lon != null) {
      setState(() {
        coordenadas.add({'latitude': lat, 'longitude': lon});
      });

      latitudeController.clear();
      longitudeController.clear();
    }
  }

  Future<void> abrirMapa(double lat, double lon) async {
    final Uri mapsMeUri = Uri.parse("mapsme://map?ll=$lat,$lon&z=15");
    final Uri googleMapsUri = Uri.parse(
      "geo:$lat,$lon?q=$lat,$lon(Google Maps)",
    );
    final Uri webMapsUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lon",
    );

    if (await canLaunch(mapsMeUri.toString())) {
      await launchUrl(mapsMeUri, mode: LaunchMode.externalApplication);
    }
    if (await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication)) {
      return;
    }
    if (await launchUrl(webMapsUri, mode: LaunchMode.externalApplication)) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Erro ao abrir o mapa.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Coordenadas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: "Latitude"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: "Longitude"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: adicionarCoordenada,
              child: Text("Adicionar Coordenada"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: coordenadas.length,
                itemBuilder: (context, index) {
                  final coord = coordenadas[index];
                  return ListTile(
                    title: Text(
                      "Lat: ${coord['latitude']}, Lon: ${coord['longitude']}",
                    ),
                    trailing: Icon(Icons.map),
                    onTap:
                        () =>
                            abrirMapa(coord['latitude']!, coord['longitude']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
