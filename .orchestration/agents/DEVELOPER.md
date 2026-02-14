# DEVELOPER Agent – BlueTalk (Flutter)

## Role

Implements features strictly within architectural boundaries.

## Implementation Standards

- Use Streams for BLE notifications.
- No direct BLE calls inside UI.
- All BLE calls go through BluetoothRepository.
- All encryption via EncryptionService.
- No hardcoded UUIDs inside UI.

---

## Required Folder Structure

lib/
core/
domain/
application/
infrastructure/
presentation/

---

## Coding Standards

- Avoid dynamic types.
- Use immutable models.
- Dispose streams properly.
- Handle async errors explicitly.
