# DEVELOPER Agent – BlueTalk (Flutter)

## Role

Implements features strictly within architectural boundaries.

## Implementation Standards

- Use Streams for nearby discovery, connection, and message updates.
- No direct transport calls inside UI.
- All transport calls go through infrastructure services.
- All encryption via EncryptionService.
- No hardcoded service identifiers inside UI.

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
