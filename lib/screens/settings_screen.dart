import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'lock_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';
  String _lockType = 'pin'; // Varsayılan

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getAppInfo();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lockType = prefs.getString('lockType') ?? 'pin';
    });
  }

  Future<void> _getAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version}+${info.buildNumber}';
    });
  }

  Future<void> _updateLockType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lockType', type);
    setState(() {
      _lockType = type;
    });
    // Kullanıcıya bildirim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type şifresi ayarlandı. Değişiklikler için uygulamayı yeniden başlatın.')),
    );
  }

  void _checkForUpdates() {
    // Basit bir kontrol mantığı (örneğin hardcoded son versiyon)
    const String currentVersion = '1.0.0';
    const String latestVersion = '1.0.1'; // Örnek
    
    if (currentVersion == latestVersion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Güncel versiyon kullanıyorsunuz.')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Güncelleme Mevcut'),
          content: Text('Yeni versiyon: $latestVersion. Lütfen dosyayı indirin ve kurun.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Güvenlik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListTile(
            title: const Text('Şifre Türü'),
            subtitle: Text('Şu anki: $_lockType'),
            trailing: PopupMenuButton<String>(
              onSelected: _updateLockType,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'pin', child: Text('PIN')),
                const PopupMenuItem(value: 'pattern', child: Text('Desen')),
                const PopupMenuItem(value: 'none', child: Text('Yok')),
              ],
              child: const Icon(Icons.edit),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Uygulama', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListTile(
            title: const Text('Sürüm'),
            subtitle: Text(_version),
          ),
          ListTile(
            title: const Text('Güncellemeleri Kontrol Et'),
            subtitle: const Text('Manuel güncelleme kontrolü'),
            onTap: _checkForUpdates,
          ),
          const Divider(),
          ListTile(
            title: const Text('Uygulamayı Kilitle'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LockScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}