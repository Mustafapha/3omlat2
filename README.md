# P2P Demo (Flutter)

Demo-Prototyp. Keine echten Zahlungen, Wallets oder Krypto-Transaktionen.

## Einrichten
1. Flutter SDK installieren: https://docs.flutter.dev/get-started/install
2. Android Studio installieren (nur für Android SDK + Emulator), Emulator anlegen (Device Manager)
3. VS Code installieren, Extension "Flutter" installieren
4. Terminal: `flutter doctor` ausführen und offene Punkte beheben (`flutter doctor --android-licenses`)
5. Neues Projekt erstellen: `flutter create p2p_demo`
6. In den Ordner p2p_demo: den Ordner `lib` löschen und durch den `lib`-Ordner aus diesem Paket ersetzen, `pubspec.yaml` ersetzen
7. `flutter pub get`

## Starten
1. Ordner p2p_demo in VS Code öffnen (File > Open Folder)
2. Unten rechts das Gerät wählen, Android-Emulator starten
3. F5 drücken (oder `flutter run` im Terminal)

## Struktur
lib/models: Datenmodelle | lib/services: Preis-API, Commission | lib/state: App-Zustand | lib/screens: UI
