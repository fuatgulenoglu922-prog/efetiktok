import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/lock_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/note_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EfetiKtokApp());
}

class EfetiKtokApp extends StatelessWidget {
  const EfetiKtokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: MaterialApp(
        title: 'EfetiKtok',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        darkTheme: ThemeData.dark(),
        home: const AuthWrapper(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLocked = prefs.getBool('isLocked') ?? true;
    setState(() {
      _isLocked = isLocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLocked ? const LockScreen() : const HomeScreen();
  }
}