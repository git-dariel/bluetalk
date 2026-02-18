# BlueTalk AI Orchestration System (Flutter Edition)

BlueTalk is a Bluetooth peer-to-peer messaging application built with:

- Flutter (Dart)
- Google Nearby Connections API (`nearby_connections`)
- Clean Architecture
- AES-GCM encryption pipeline (planned for transport re-integration)
- ECDH key exchange pipeline (planned for transport re-integration)

Transport layer uses Nearby Connections for discovery, connection, and
messaging over Bluetooth transports (with optional WiFi Direct upgrade).

This AI orchestration layer governs development to ensure:

- Strict architectural boundaries
- Secure Bluetooth communication
- Cryptographic enforcement roadmap (currently in progress)
- Offline-first reliability
- Battery-aware operation

Current transport state:

- Nearby Connections discovery, connection, and messaging are active.
- Encryption-on-transport is tracked as a roadmap item in `.orchestration/TODO.md`.

No feature bypasses architectural review.
No Bluetooth logic is written outside infrastructure layer.
No business logic exists inside UI widgets.
