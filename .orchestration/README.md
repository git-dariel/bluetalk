# BlueTalk AI Orchestration System (Flutter Edition)

BlueTalk is a Bluetooth Low Energy (BLE) peer-to-peer encrypted messaging application built with:

- Flutter (Dart)
- flutter_reactive_ble
- Clean Architecture
- AES-GCM encryption
- ECDH key exchange

This AI orchestration layer governs development to ensure:

- Strict architectural boundaries
- Secure BLE communication
- Cryptographic enforcement
- Offline-first reliability
- Battery-aware operation

No feature bypasses architectural review.
No BLE logic is written outside infrastructure layer.
No message is sent unencrypted.
