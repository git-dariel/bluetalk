# Global Engineering Rules – BlueTalk (Flutter)

1. Clean Architecture must be preserved.
2. Bluetooth logic only exists inside infrastructure layer.
3. Domain layer must be Flutter-independent.
4. All messages must be encrypted (AES-GCM).
5. ECDH handshake required before session activation.
6. No plaintext payloads.
7. No business logic inside UI widgets.
8. All BLE operations must handle:
   - Disconnection
   - Timeout
   - Permission denial
9. All streams must be properly disposed.
10. Power consumption impact must be evaluated for every scanning feature.

---

## UI / UX GOVERNANCE

1. Figma is the single source of truth for visual design.
2. No UI changes without design review.
3. Spacing, typography, and color tokens must match Figma design system.
4. Do not introduce new colors, shadows, or layout patterns unless approved.
5. All components must follow defined spacing scale.
6. Interaction states (hover, active, loading, disabled) must be implemented as designed.
7. UI consistency overrides personal design preference.
