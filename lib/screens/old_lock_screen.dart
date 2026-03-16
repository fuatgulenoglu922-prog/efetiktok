import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'home_screen.dart';
import 'setup_pin_screen.dart';
import 'setup_pattern_screen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String? lockType;
  String? storedPin;
  List<int>? storedPattern;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _loadLockSettings();
    _checkBiometrics();
  }

  Future<void> _loadLockSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lockType = prefs.getString('lockType');
      storedPin = prefs.getString('storedPin');
      // Pattern stored as string "1-2-3" etc, parsing needed if complex
    });
  }

  Future<void> _checkBiometrics() async {
    bool canCheck = await auth.canCheckBiometrics;
    setState(() {
      _canCheckBiometrics = canCheck;
    });
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Uygulamayı açmak için parmak izi kullanın',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        _unlockApp();
      }
    } catch (e) {
      print(e);
    }
  }

  void _unlockApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (lockType == null) {
      // Henüz şifre ayarlanmamış, kurulum ekranına git
      return const SetupPinScreen(); // Veya SetupSelectionScreen
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'EfetiKtok',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            if (lockType == 'pin') ...[
              _buildPinEntry(),
            ] else if (lockType == 'pattern') ...[
              _buildPatternEntry(),
            ],
            const SizedBox(height: 20),
            if (_canCheckBiometrics)
              IconButton(
                icon: const Icon(Icons.fingerprint, size: 40),
                onPressed: _authenticate,
                tooltip: 'Parmak izi ile aç',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinEntry() {
    return Column(
      children: [
        const Text('PIN girin'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.all(4),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        // Basit klavye
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(9, (index) {
            return ElevatedButton(
              onPressed: () {
                // PIN kontrolü mantığı buraya eklenecek
                // Şimdilik basitçe geçiş
                if (storedPin == '1234') _unlockApp(); // Demo
              },
              child: Text('${index + 1}'),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPatternEntry() {
    return Column(
      children: [
        const Text('Desen çizin'),
        const SizedBox(height: 20),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.all(20),
            children: List.generate(9, (index) {
              return Center(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
             // Demo geçiş
             _unlockApp();
          },
          child: const Text('Desen Onayla (Demo)'),
        )
      ],
    );
  }
}