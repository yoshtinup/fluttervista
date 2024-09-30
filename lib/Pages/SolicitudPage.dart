import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_movil/Pages/NextPage.dart';
import 'package:app_movil/Pages/ThirdPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final Map<String, String> userInfo = const {
    "name": "Yoshtin German Gutierrez Perez",
    "id": "221246",
    "phone": "961 851 3478",
    "imageUrl": "assets/images/logo.jpeg", // Reemplaza con la URL real de la imagen
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoCard(),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              'Imágenes de Personajes',
              Colors.orange,
              const NextPage(),
            ),
            const SizedBox(height: 10),
            _buildNavigationButton(
              context,
              'Regrasar Página Principal',
              Colors.blue,
              const ThirdPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userInfo['imageUrl']!),
            ),
            const SizedBox(height: 16),
            Text(
              userInfo['name']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "ID: ${userInfo['id']}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactButton(
                  icon: Icons.phone,
                  label: 'Llamar',
                  onPressed: () => _makePhoneCall(userInfo['phone']!),
                ),
                _buildContactButton(
                  icon: Icons.message,
                  label: 'Mensaje',
                  onPressed: () => _sendSMS(userInfo['phone']!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String label,
    Color color,
    Widget destination,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'No se pudo realizar la llamada';
    }
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'No se pudo enviar el mensaje';
    }
  }
}