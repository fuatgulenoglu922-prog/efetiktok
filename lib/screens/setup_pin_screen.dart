import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  String _pin = '';
  String _confirmPin = '';
  int _step = 0; // 0: PIN gir, 1: Onayla

  void _addDigit(String digit) {
    if (_step == 0) {
      if (_pin.length < 4) {
        setState(() => _pin += digit);
      }
    } else {
      if (_confirmPin.length < 4) {
        setState(() => _confirmPin += digit);
      }
    }
  }

  void _removeDigit() {
    if (_step == 0) {
      if (_pin.isNotEmpty) {
        setState(() => _pin = _pin.substring(0, _pin.length - 1));
      }
    } else {
      if (_confirmPin.isNotEmpty) {
        setState(() => _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1));
      }
    }
  }

  Future<void> _savePin() async {
    if (_pin != _confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINler uyuşmuyor!')),
      );
      setState(() {
        _confirmPin = '';
        _step = 1;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lockType', 'pin');
    await prefs.setString('storedPin', _pin);
    await prefs.setBool('isLocked', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _step == 0 ? 'PIN Oluştur' : 'PIN Onayla',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                String digit = _step == 0 ? _pin : _confirmPin;
                bool isFilled = index < digit.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isFilled ? Colors.blue : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            // Klavye
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(12, (index) {
                if (index == 9) return const SizedBox(width: 70); // Boşluk
                if (index == 10) {
                  return SizedBox(
                    width: 70,
                    height: 70,
                    child: IconButton(
                      icon: const Icon(Icons.backspace),
                      onPressed: _removeDigit,
                    ),
                  );
                }
                if (index == 11) {
                  return SizedBox(
                    width: 70,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: _step == 0
                          ? () => setState(() => _step = 1)
                          : _savePin,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: Text(_step == 0 ? 'OK' : '✓'),
                    ),
                  );
                }
                return SizedBox(
                  width: 70,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () => _addDigit('${index + 1}'),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: Text('${index + 1}'),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}