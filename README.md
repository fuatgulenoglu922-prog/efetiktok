# EfetiKtok

Güçlü alt yapılı, offline, şifre korumalı not alma uygulaması.

## Özellikler

- **Offline Çalışma:** Tüm veriler cihazda saklanır.
- **Şifreleme:** PIN, Desen ve Parmak İzi desteği.
- **Not Alma:** Basit ve modern arayüz.
- **Güncelleme Sistemi:** Uygulama içi güncelleme kontrolü.

## Kurulum

1. Flutter SDK'sını kurun: [flutter.dev](https://flutter.dev)
2. Projeyi klonlayın:
   ```bash
   git clone <repo-url>
   cd efetiktok
   ```
3. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## APK Oluşturma

```bash
flutter build apk --release
```

## GitHub Actions

Bu proje GitHub Actions ile otomatik APK build eder. `main` branch'ine push attığınızda, GitHub sunucuları APK dosyasını oluşturur ve Release olarak yayınlar.

## Lisans

MIT