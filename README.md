# BlueTalk

BlueTalk is a Bluetooth Low Energy (BLE) peer-to-peer messaging app built with Flutter. It focuses on secure, offline-first communication using encrypted sessions and clean architecture boundaries.

## Highlights

- Encrypted messaging with AES-GCM
- Ephemeral session keys derived via ECDH
- Offline-first BLE communication
- Clean Architecture separation of concerns
- Battery-aware BLE scanning and connection handling

## Architecture Diagram

```mermaid
flowchart LR
	subgraph Presentation
		UI[Flutter UI]
	end
	subgraph Application
		App[App Layer]
	end
	subgraph Domain
		UseCases[Use Cases]
		Entities[Entities]
	end
	subgraph Data
		Repos[Repositories]
		BLE[BLE Infrastructure]
		Crypto[Crypto Services]
	end
	subgraph Security
		Storage[In-Memory Session Keys]
	end

	UI --> App --> UseCases --> Entities
	App --> Repos --> BLE --> Device[Nearby Device]
	Repos --> Crypto --> BLE
	Crypto --> Storage

	classDef layer fill:#1f2933,stroke:#4b5563,color:#e5e7eb;
	classDef accent fill:#0f766e,stroke:#0ea5a4,color:#f0fdfa;
	class UI,App,UseCases,Entities,Repos,BLE,Crypto,Storage layer;
	class Device accent;
```

## Documentation

- Architecture and engineering rules are in [.orchestration/README.md](.orchestration/README.md) and [.orchestration/ARCHITECTURE.md](.orchestration/ARCHITECTURE.md).
- Security specifications are in [.orchestration/security/PROTOCOL.md](.orchestration/security/PROTOCOL.md) and [.orchestration/security/THREAT_MODEL.md](.orchestration/security/THREAT_MODEL.md).

## Requirements

- Flutter SDK (stable channel)
- Platform toolchains for Android and iOS

## Quick Start

```bash
flutter pub get
flutter run
```

## Status

Active development. Protocols and security hardening are evolving.
