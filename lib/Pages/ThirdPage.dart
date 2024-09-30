import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_movil/Pages/NextPage.dart';
import 'package:app_movil/Pages/SolicitudPage.dart';
import 'package:app_movil/Pages/InicioPage.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ThirdPage());

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuario',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 72, 255),
          brightness: Brightness.dark, // Cambiado a tema oscuro
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Fondo del AppBar en negro
          foregroundColor: Colors.white, // Texto blanco en el AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[600], // Color del botón
            foregroundColor: Colors.white, // Texto blanco
          ),
        ),
      ),
      home: const PaginaComida(),
    );
  }
}

class PaginaComida extends StatefulWidget {
  const PaginaComida({super.key});

  @override
  _PaginaComidaState createState() => _PaginaComidaState();
}

class _PaginaComidaState extends State<PaginaComida>
  with SingleTickerProviderStateMixin {
  late TabController _controladorTab;
  final TextEditingController _controladorTexto = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controladorTab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controladorTab.dispose();
    _controladorTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Rick and Morty Episodes'),
        ),
        bottom: TabBar(
          controller: _controladorTab,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Inicio'),
            Tab(icon: Icon(Icons.list), text: 'Episodios'),
            Tab(icon: Icon(Icons.account_box_sharp), text: 'Solicitudes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controladorTab,
        children: [
          InicioPage(),
          _construirPestanaCategorias(),
          _construirPestanaConfiguracion(),
        ],
      ),
    );
  }

  Widget _construirPestanaCategorias() {
    return FutureBuilder<List<dynamic>>(
      future: fetchEpisodes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color.fromARGB(255, 100, 5, 26), // Fondo oscuro para la tarjeta
                child: ListTile(
                  title: Text(snapshot.data![index]['name'],
                      style: const TextStyle(color: Colors.white)),
                  leading: const Icon(Icons.category, color: Colors.grey),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<dynamic>> fetchEpisodes() async {
    final response =
        await http.get(Uri.parse('https://rickandmortyapi.com/api/episode'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Failed to load episodes');
    }
  }

  Widget _construirPestanaConfiguracion() {
    return Scaffold(

      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 100, 5, 26), // Botón color naranja
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NextPage()),
                );
              },
              child: const Text(
                'Imagenes Personajes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 100, 5, 26), // Otro botón con el mismo estilo
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text(
                'Solicitudes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
