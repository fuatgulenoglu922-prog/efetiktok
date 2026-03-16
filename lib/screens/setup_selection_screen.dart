import 'package:flutter/material.dart';
import 'setup_pin_screen.dart';
import 'setup_pattern_screen.dart';

class SetupSelectionScreen extends StatelessWidget {
  const SetupSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hoş Geldiniz!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Uygulama güvenliği için bir şifre türü seçin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              _buildOption(
                context,
                'PIN',
                '4 haneli sayısal şifre',
                Icons.pin,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupPinScreen()),
                ),
              ),
              const SizedBox(height: 20),
              _buildOption(
                context,
                'Desen',
                'Noktaları birleştirerek desen çizin',
                Icons.panorama_fish_eye,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupPatternScreen()),
                ),
              ),
              const SizedBox(height: 20),
              _buildOption(
                context,
                'Parmak İzi',
                'Cihazınızın parmak izi sensörünü kullanın',
                Icons.fingerprint,
                () {
                  // Parmak izi kurulumu genellikle cihaz ayarlarından yapılır
                  // Burada basitçe PIN veya Desen seçtikten sonra aktif edilebilir
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen önce PIN veya Desen seçin.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}