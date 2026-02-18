# BlueTalk Task Board (Flutter)

---

## Agent Ownership

- ARCHITECT: protocol/security design authority and cryptographic approvals
- PROJECT_PLANNER: task decomposition and sequencing
- DEVELOPER: implementation
- REVIEWER: architecture/security code review gate
- QA: test validation and failure simulation
- PM: cross-agent coordination and delivery tracking

---

## CURRENTLY DONE (KEEP)

- [x] Migrate runtime transport to Nearby Connections (Owner: DEVELOPER)
- [x] Implement Nearby discovery + connect + messaging flow in infrastructure/controller layers (Owner: DEVELOPER, Review: REVIEWER)
- [x] Keep business logic out of widgets and use controller-driven state updates (Owner: DEVELOPER, Review: REVIEWER)
- [x] Complete shell flow: landing → permission → main tabs (Owner: DEVELOPER)
- [x] Add connect action in HomeTab and thread routing per endpoint ID (Owner: DEVELOPER)
- [x] Build and validate APK on real Android device (Owner: QA)
- [x] Validate two-device discovery and real-time message exchange end-to-end (Owner: QA)
- [x] Remove unused legacy crypto/session repository files from active codebase (Owner: DEVELOPER)
- [x] Rename BLE infrastructure to ConnectivityPermissionService under infrastructure/nearby (Owner: DEVELOPER)
- [x] Bundle IMFellEnglish and Poppins as local TTF assets — removed runtime GoogleFonts dependency (Owner: DEVELOPER)
- [x] Show connected snackbar with "Go to Messages" action on successful peer connection (Owner: DEVELOPER)
- [x] Add per-tile loading state (spinner + "Connecting..." subtitle) while connection handshake is in-flight (Owner: DEVELOPER)
- [x] Auto-stop scanning and turn off toggle after a peer successfully connects (Owner: DEVELOPER)
- [x] Clear "Connecting to..." status message on success — tile state is sufficient feedback (Owner: DEVELOPER)

---

## IMPLEMENT SOON (NEXT SPRINT)

- [ ] Re-integrate AES-GCM encryption on Nearby payload send/receive path (Owner: ARCHITECT, Implementer: DEVELOPER, Review: REVIEWER)
- [ ] Add handshake/session activation before first message send (Owner: DEVELOPER, Review: REVIEWER)
- [ ] Enforce encrypted-only messaging path (no plaintext fallback) (Owner: ARCHITECT, Implementer: DEVELOPER)
- [ ] Add delivery state in UI (sending/sent/failed) for outgoing messages (Owner: DEVELOPER, QA: QA)
- [ ] Document payload size/chunking strategy for encrypted Nearby messages (Owner: PROJECT_PLANNER, Implementer: DEVELOPER)

---

## QA VALIDATION (BLOCKERS FOR MERGE)

- [ ] Simulate replay attack (Owner: QA, Support: DEVELOPER)
- [ ] Simulate invalid key / malformed handshake payload (Owner: QA, Support: DEVELOPER)
- [ ] Simulate corrupted ciphertext handling (Owner: QA, Support: DEVELOPER)
- [ ] Simulate forced disconnect during handshake/message send (Owner: QA, Support: DEVELOPER)
- [ ] Validate reconnect and session-expiration behavior (Owner: QA, Support: DEVELOPER)

---

## LATER (NOT IMMEDIATE)

- [ ] Add multi-peer group chat support (Owner: ARCHITECT, Implementer: DEVELOPER)
- [ ] Add media/file sharing via Nearby FILE payload (Owner: DEVELOPER, Review: REVIEWER)
- [ ] Persist chat history locally (SQLite/Hive) (Owner: DEVELOPER)
- [ ] Add QR code pairing for identity verification (Owner: ARCHITECT, Implementer: DEVELOPER)
- [ ] Add background notification handling for inbound messages (Owner: DEVELOPER)
- [ ] Implement connection quality indicator in UI (Owner: DEVELOPER)
