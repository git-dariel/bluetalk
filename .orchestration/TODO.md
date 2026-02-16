# BlueTalk Task Board (Flutter)

---

## Agent Ownership

- ARCHITECT: protocol/security design authority and cryptographic approvals
- PROJECT_PLANNER: task decomposition and sequencing
- DEVELOPER: implementation
- REVIEWER: architecture/security code review gate
- QA: test validation and failure simulation
- PM: cross-agent coordination and delivery tracking

## FOUNDATION – BLE & CRYPTO CORE

## BLE Protocol Definition

- [x] Define BlueTalk Service UUID (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Define Handshake Characteristic UUID (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Define Message Characteristic UUID (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Define Acknowledgment Characteristic UUID (Owner: ARCHITECT, Implementer: DEVELOPER)
- [ ] Document MTU constraints and packet fragmentation strategy (Owner: PROJECT_PLANNER, Implementer: DEVELOPER, Review: REVIEWER)

## Secure Handshake Implementation (CRITICAL)

- [x] Generate ephemeral ECDH P-256 key pair (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Implement public key serialization (base64) (Owner: DEVELOPER)
- [x] Implement public key exchange over BLE (Owner: DEVELOPER, Review: REVIEWER)
- [x] Compute shared secret (ECDH) (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Derive AES-256 session key via HKDF-SHA256 (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Implement session confirmation via HMAC (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Validate confirmation before activating session (Owner: DEVELOPER, QA: QA)
- [x] Store session key in memory only (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Implement session expiration timer (Owner: DEVELOPER, QA: QA)
- [x] Implement session reset on disconnect (Owner: DEVELOPER, QA: QA)

---

## ENCRYPTED MESSAGING

- [x] Implement AES-GCM encryption service (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Generate unique nonce per message (Owner: DEVELOPER)
- [x] Implement nonce tracking to prevent replay (Owner: DEVELOPER, QA: QA)
- [x] Validate timestamp tolerance window (Owner: DEVELOPER, QA: QA)
- [x] Implement message packet schema validation (Owner: DEVELOPER, Review: REVIEWER)
- [x] Implement encrypted message send (Owner: DEVELOPER)
- [x] Implement encrypted message receive (Owner: DEVELOPER)
- [x] Implement message acknowledgment logic (Owner: DEVELOPER, Review: REVIEWER)

---

## SECURITY HARDENING (PHASE 2)

- [x] Add long-term device identity key pair (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Sign ephemeral public key (Owner: ARCHITECT, Implementer: DEVELOPER)
- [x] Verify signature to mitigate MITM (Owner: ARCHITECT, Implementer: DEVELOPER, QA: QA)
- [x] Implement session integrity logging (Owner: DEVELOPER, Review: REVIEWER)
- [x] Add failed-handshake rate limiting (Owner: DEVELOPER, QA: QA)
- [x] Add invalid packet detection and rejection (Owner: DEVELOPER, QA: QA)

---

## RELIABILITY

- [x] Heartbeat mechanism (Owner: DEVELOPER, QA: QA)
- [x] Auto-reconnect strategy (Owner: DEVELOPER, Review: REVIEWER)
- [x] BLE timeout handling (Owner: DEVELOPER, QA: QA)
- [x] Graceful session teardown (Owner: DEVELOPER, QA: QA)

---

## TESTING & VALIDATION

- [ ] Simulate replay attack (Owner: QA, Support: DEVELOPER)
- [ ] Simulate invalid public key (Owner: QA, Support: DEVELOPER)
- [ ] Simulate corrupted ciphertext (Owner: QA, Support: DEVELOPER)
- [ ] Simulate forced disconnection during handshake (Owner: QA, Support: DEVELOPER)
- [ ] Validate session expiration behavior (Owner: QA, Support: DEVELOPER)

---

## PM Tracking Gates

- [x] PM confirms status flow per task: Proposed → Architect Approved → Dev In Progress → Review → QA → Completed
- [ ] PM blocks feature merge if security-critical prerequisites are incomplete

---

## UI/UX FLOW IMPLEMENTATION

- [x] Implement landing screen flow (Start action) (Owner: DEVELOPER, Review: REVIEWER)
- [x] Implement permission screen flow (Allow & Continue) (Owner: DEVELOPER, QA: QA)
- [x] Implement app shell with 3-tab navigation: Home, Chat, Settings (Owner: DEVELOPER)
- [x] Implement Home UI: nearby users list, scan toggle, scanning/empty states (Owner: DEVELOPER)
- [x] Implement Chat list UI and chat detail conversation UI (Owner: DEVELOPER)
- [x] Implement Settings UI: profile card, clear history action, about page (Owner: DEVELOPER)
- [x] Implement username update modal interaction (Owner: DEVELOPER, QA: QA)
- [x] Implement clear history confirmation modal interaction (Owner: DEVELOPER, QA: QA)
- [x] Align color, spacing, radius, and typography with DESIGN_SYSTEM.md and reference design (Owner: DEVELOPER, Review: REVIEWER)
- [x] Validate responsive behavior and overflow safety on small screens (Owner: QA, Support: DEVELOPER)

---

## APP INTEGRATION – BLE RUNTIME FLOW (CURRENT)

- [x] Request runtime Bluetooth permission before entering shell (Owner: DEVELOPER, QA: QA)
- [x] Start BLE scan when permission is granted and scan toggle is enabled (Owner: DEVELOPER)
- [x] Stream discovered nearby devices into Home nearby users list (Owner: DEVELOPER, Review: REVIEWER)
- [x] Bind chat detail send action to encrypted messaging service path (Owner: DEVELOPER, Review: REVIEWER)
- [x] Keep BLE/session logic out of UI widgets and inside controller/infrastructure layers (Owner: DEVELOPER, Review: REVIEWER)
- [x] Implement real BLE packet transport repository for two physical devices (Owner: DEVELOPER, Review: REVIEWER, QA: QA)
- [x] Validate two-physical-device nearby discovery and message exchange end-to-end (Owner: QA, Support: DEVELOPER)

---

## TRANSPORT MIGRATION – NEARBY CONNECTIONS (COMPLETED)

Migrated from raw BLE GATT transport to Google Nearby Connections API (`nearby_connections: ^4.3.0`).
Reason: BLE GATT was too fragile (MTU fragmentation, GATT server/client complexity, unreliable on many devices).

- [x] Create NearbyConnectionsChatService (advertising + discovery + connection + messaging) (Owner: DEVELOPER)
- [x] Replace NearbyUserDiscoveryService (BLE scanning) with Nearby Connections discovery (Owner: DEVELOPER)
- [x] Replace InMemoryBluetoothRepository (loopback mock) with real Nearby Connections payload transport (Owner: DEVELOPER)
- [x] Refactor ShellController to use NearbyConnectionsChatService (Owner: DEVELOPER, Review: REVIEWER)
- [x] Simplify app_flow.dart wiring (removed session/crypto/reliability dependencies from transport) (Owner: DEVELOPER)
- [x] Update NearbyUser model with endpointId and isConnected status (Owner: DEVELOPER)
- [x] Add "Tap to connect" UI in HomeTab for discovered peers (Owner: DEVELOPER)
- [x] Auto-accept connections and auto-create chat threads on connect (Owner: DEVELOPER)
- [x] Route messages to correct peer via endpoint ID mapping (Owner: DEVELOPER)
- [x] Add WiFi, Location, and Nearby permissions to AndroidManifest.xml (Owner: DEVELOPER)
- [x] Add bluetoothAdvertise and nearbyWifiDevices to permission service (Owner: DEVELOPER)
- [x] Generate app launcher icon from landing_page.jpeg (Owner: DEVELOPER)
- [x] Build and verify APK on physical device (Infinix X6880, Android 15) (Owner: QA)
- [x] Validate two-device discovery and real-time chat end-to-end (Owner: QA)

---

## FUTURE ENHANCEMENTS

- [ ] Add message delivery status indicators (sent, delivered, read) (Owner: DEVELOPER, Review: REVIEWER)
- [ ] Re-integrate AES-GCM encryption on top of Nearby Connections payload (Owner: ARCHITECT, Implementer: DEVELOPER)
- [ ] Add multi-peer group chat support (Owner: ARCHITECT, Implementer: DEVELOPER)
- [ ] Add media/file sharing via Nearby Connections FILE payload (Owner: DEVELOPER, Review: REVIEWER)
- [ ] Persist chat history locally with SQLite/Hive (Owner: DEVELOPER)
- [ ] Add QR code pairing for identity verification (Owner: ARCHITECT, Implementer: DEVELOPER)
- [ ] Add push notification for incoming messages when app is backgrounded (Owner: DEVELOPER)
- [ ] Implement connection quality indicator based on Nearby Connections bandwidth (Owner: DEVELOPER)
