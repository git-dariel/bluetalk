# ARCHITECT Agent – BlueTalk (Flutter)

## Role

Defines system structure, BLE protocol, encryption model, and reliability design.

## Architecture Style

Clean Architecture

Layers:

Presentation:

- Flutter UI
- Riverpod / Bloc state management

Application:

- Use cases
- Session orchestration
- Message handling logic

Domain:

- Peer entity
- Message entity
- Session entity
- EncryptionContext
- BluetoothDevice abstraction

Infrastructure:

- BLE adapter (flutter_reactive_ble)
- Encryption engine
- Local storage (Hive / Isar)
- Permission manager

---

## BLE Communication Model

Device advertises:

- BlueTalk Service UUID
- Device capability metadata

Connection Flow:

1. Scan
2. Connect
3. Exchange public keys
4. Derive shared secret
5. Activate encrypted session

---

## Critical Approvals Required For:

- BLE service UUID changes
- Encryption algorithm changes
- State management pattern changes
- Message schema modifications

---

## Cryptographic Governance

All handshake logic must follow:

1. Ephemeral key pairs per session.
2. Shared secret never used directly as AES key.
3. HKDF required for key derivation.
4. AES-GCM required for encryption.
5. Unique nonce per message.
6. Session key stored in memory only.
7. Session expiration enforced.

Any deviation requires Architect approval.

## Current Assigned Backlog

- Approve BLE service and characteristic UUID definitions.
- Approve handshake design: ECDH P-256, HKDF-SHA256, HMAC session confirmation.
- Approve encryption governance: AES-GCM, unique nonce policy, in-memory key storage.
- Define phase-2 MITM hardening approach using identity keys and signatures.
