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

---

## UI/UX Compliance Policy

All UI implementation must strictly follow the approved Figma design.

Requirements:

- Match layout hierarchy.
- Match typography scale.
- Match color tokens.
- Match border radius.
- Match spacing system.
- Implement all interaction states.

No visual improvisation allowed.

If design conflict occurs:

- Pause implementation.
- Request clarification via ARCHITECT or PM agent.

## Current Assigned Backlog

- Implement BLE protocol constants and packet schema handling.
- Implement handshake flow and session lifecycle controls.
- Implement AES-GCM encryption/decryption and nonce tracking.
- Implement encrypted send/receive and acknowledgment logic.
- Implement reliability controls: timeout handling, reconnect strategy, graceful teardown.
