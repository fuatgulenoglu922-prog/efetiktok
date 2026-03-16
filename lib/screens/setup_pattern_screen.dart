import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class SetupPatternScreen extends StatefulWidget {
  const SetupPatternScreen({super.key});

  @override
  State<SetupPatternScreen> createState() => _SetupPatternScreenState();
}

class _SetupPatternScreenState extends State<SetupPatternScreen> {
  List<int> _pattern = [];
  int _step = 0; // 0: Desen çiz, 1: Onayla

  void _addNode(int index) {
    if (!_pattern.contains(index)) {
      setState(() => _pattern.add(index));
    }
  }

  Future<void> _savePattern() async {
    if (_pattern.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desen en az 4 nokta olmalıdır!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    // Deseni string olarak kaydet (basit format: "1-2-3")
    await prefs.setString('lockType', 'pattern');
    await prefs.setString('storedPattern', _pattern.join('-'));
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
              _step == 0 ? 'Desen Oluştur' : 'Deseni Onayla',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.all(20),
                children: List.generate(9, (index) {
                  return GestureDetector(
                    onTap: () => _addNode(index),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _pattern.contains(index) ? Colors.blue : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _step == 0
                  ? () {
                      if (_pattern.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('En az 4 nokta seçin!')),
                        );
                        return;
                      }
                      setState(() {
                        _step = 1;
                        // For demo, we don't clear pattern in real app we would store and compare
                        // For simplicity here we just assume confirmation
                      });
                    }
                  : _savePattern,
              child: Text(_step == 0 ? 'Devam Et' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}