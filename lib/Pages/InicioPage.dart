import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  Map<String, dynamic>? character;
  bool isLoading = true;
  final TextEditingController _textController = TextEditingController();
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    fetchRandomCharacter();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> fetchRandomCharacter() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://rickandmortyapi.com/api/character/${(1 + (DateTime.now().millisecondsSinceEpoch % 671))}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          character = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load character');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        character = null;
        isLoading = false;
      });
    }
  }

  void _onButtonPressed() {
    setState(() {
      _displayText = _textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick and Morty Multiverso'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Bienvenido al Multiverso de Rick and Morty',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      if (isLoading)
                        CircularProgressIndicator()
                      else if (character != null)
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(character!['image']),
                            ),
                            SizedBox(height: 10),
                            Text(
                              character!['name'],
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text('Especie: ${character!['species']}'),
                            Text('Estado: ${character!['status']}'),
                            Text('Origen: ${character!['origin']['name']}'),
                          ],
                        )
                      else
                        Text('No se pudo cargar el personaje. Intenta de nuevo.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : fetchRandomCharacter,
                child: Text('Cargar otro personaje'),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Ingrese su comentario',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _onButtonPressed,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(fontSize: 18.0),
                  ),
                ),
                child: Text('Guardar Comentario'),
              ),
              SizedBox(height: 16.0),
              Text(
                _displayText.isEmpty ? 'No hay texto ingresado.' : _displayText,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}