# BlueTalk Architecture (Flutter + Nearby Connections)

## System Type

Offline-first Bluetooth peer-to-peer messaging system.

## Communication Layer

Transport: Google Nearby Connections API (P2P_CLUSTER strategy)
Service ID: `com.bluetalk.nearby`

Nearby Connections automatically selects the best available transport:

1. Nearby discovery channel — finding nearby devices
2. Bluetooth channel — message data transfer
3. WiFi Direct — optional, used for faster/larger transfers

Previous low-level transport approach was replaced
due to fragmentation, MTU, and implementation complexity issues.

---

## Application Layers

### Infrastructure Layer

- `NearbyConnectionsChatService` — advertising, discovery, connection, payload messaging
- `BluetoothPermissionService` — runtime permission requests (Bluetooth, location, WiFi)
- Cryptographic services (ECDH, AES-GCM, HKDF) — implemented and awaiting transport re-integration

### Presentation Layer

- `ShellController` — app state, scan toggle, thread/message management
- `AppFlowController` — landing → permission → shell navigation
- Screens and tabs: HomeTab, MessagesTab, SettingsTab, ChatDetailScreen

### Domain Layer (Flutter-independent)

- Entities: Session, EncryptedMessagePacket, HandshakeModels
- Repository interfaces: BluetoothRepository, CryptoRepository, SessionStore

---

## Secure Handshake Flow (Target Re-Integration)

1. Device A connects to Device B
2. Exchange public keys (ECDH)
3. Derive shared secret
4. Generate symmetric AES session key
5. Confirm session activation

---

## Message Flow (Current)

1. Device A discovers Device B via Nearby Connections
2. User taps to connect → auto-accepted on both sides
3. Chat thread auto-created
4. Messages sent as JSON byte payloads via `sendBytesPayload()` (currently non-E2E)
5. Received via `onPayLoadRecieved` callback → routed to correct thread

---

## Risk Considerations

- Permission denial on Android 12+ (Bluetooth, Location, Nearby WiFi)
- OS background restrictions on scanning/advertising
- Battery drain from continuous advertising
- Connection drops during message transfer
- Multi-device collision in P2P_CLUSTER

---

## Future Evolution

- Re-integrate AES-GCM end-to-end encryption on Nearby Connections payload
- Mesh relay system
- Multi-peer group chat
- QR code secure pairing
- Secure file transfer via FILE payload
- Chat history persistence (SQLite/Hive)
