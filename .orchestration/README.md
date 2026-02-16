# BlueTalk AI Orchestration System (Flutter Edition)

BlueTalk is a Bluetooth peer-to-peer messaging application built with:

- Flutter (Dart)
- Google Nearby Connections API (`nearby_connections`)
- Clean Architecture
- AES-GCM encryption (available for re-integration)
- ECDH key exchange (available for re-integration)

Transport layer uses Nearby Connections for discovery, connection, and
messaging over BLE + Bluetooth Classic (with optional WiFi Direct upgrade).

This AI orchestration layer governs development to ensure:

- Strict architectural boundaries
- Secure Bluetooth communication
- Cryptographic enforcement (planned re-integration)
- Offline-first reliability
- Battery-aware operation

No feature bypasses architectural review.
No Bluetooth logic is written outside infrastructure layer.
No business logic exists inside UI widgets.
