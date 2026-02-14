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
