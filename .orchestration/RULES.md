# Global Engineering Rules – BlueTalk (Flutter)

1. Clean Architecture must be preserved.
2. Bluetooth/Nearby Connections logic only exists inside infrastructure layer.
3. Domain layer must be Flutter-independent.
4. All messages should be encrypted when encryption is re-integrated (AES-GCM).
5. No business logic inside UI widgets.
6. All Nearby Connections operations must handle:
   - Disconnection
   - Timeout
   - Permission denial
   - Endpoint lost
7. All streams must be properly disposed.
8. Power consumption impact must be evaluated for every scanning/advertising feature.
9. NearbyConnectionsChatService is the single service for discovery, connection, and messaging.
10. Connection state changes must be reflected in the UI immediately.

---

## UI / UX GOVERNANCE

1. Figma is the single source of truth for visual design.
2. No UI changes without design review.
3. Spacing, typography, and color tokens must match Figma design system.
4. Do not introduce new colors, shadows, or layout patterns unless approved.
5. All components must follow defined spacing scale.
6. Interaction states (hover, active, loading, disabled) must be implemented as designed.
7. UI consistency overrides personal design preference.
