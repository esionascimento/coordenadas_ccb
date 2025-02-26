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
  final List<Map<String, dynamic>> coordenadas = [
    {
      'nome': "CCB Tancredo Neves",
      'latitude': -8.760491,
      'longitude': -63.835211,
      'atualizacao': "26/02/2025",
    },
    {
      'nome': "CCB Cascalheira(Flamboyant)",
      'latitude': -8.778104,
      'longitude': -63.837291,
      'atualizacao': "26/02/2025",
    },
  ];
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void adicionarCoordenada() {
    final String nome = nomeController.text.trim();
    final double? lat = double.tryParse(latitudeController.text);
    final double? lon = double.tryParse(longitudeController.text);

    if (nome.isNotEmpty && lat != null && lon != null) {
      setState(() {
        coordenadas.add({
          'nome': nome,
          'latitude': lat,
          'longitude': lon,
          'atualizacao':
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        });
      });

      nomeController.clear();
      latitudeController.clear();
      longitudeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira valores válidos.')),
      );
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

    if (await canLaunchUrl(mapsMeUri)) {
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
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome do Local"),
            ),
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
                  return Card(
                    child: ListTile(
                      title: Text(coord['nome']),
                      subtitle: Text(
                        "Lat: ${coord['latitude']}, Lon: ${coord['longitude']}\n"
                        "Última atualização: ${coord['atualizacao']}",
                      ),
                      trailing: Icon(Icons.map),
                      onTap:
                          () =>
                              abrirMapa(coord['latitude'], coord['longitude']),
                    ),
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
