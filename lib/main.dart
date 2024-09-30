import 'package:flutter/material.dart';
import 'package:app_movil/Pages/NextPage.dart';
import 'package:app_movil/Pages/ThirdPage.dart';
import 'package:app_movil/Pages/SolicitudPage.dart';
import 'package:app_movil/Pages/InicioPage.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/third', // Ruta inicial
      routes: {
        '/home': (context) => const HomePage(), // Ruta para la página de inicio
        '/next': (context) => const NextPage(), // Ruta para la página siguiente
        '/third': (context) => const ThirdPage(),
        "/inicio":  (context) => const InicioPage(),// Ruta para la tercera página
      },
    );
  }
}
