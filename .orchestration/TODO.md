# BlueTalk Task Board (Flutter)

---

## FOUNDATION – BLE & CRYPTO CORE

## BLE Protocol Definition

- [ ] Define BlueTalk Service UUID
- [ ] Define Handshake Characteristic UUID
- [ ] Define Message Characteristic UUID
- [ ] Define Acknowledgment Characteristic UUID
- [ ] Document MTU constraints and packet fragmentation strategy

## Secure Handshake Implementation (CRITICAL)

- [ ] Generate ephemeral ECDH P-256 key pair
- [ ] Implement public key serialization (base64)
- [ ] Implement public key exchange over BLE
- [ ] Compute shared secret (ECDH)
- [ ] Derive AES-256 session key via HKDF-SHA256
- [ ] Implement session confirmation via HMAC
- [ ] Validate confirmation before activating session
- [ ] Store session key in memory only
- [ ] Implement session expiration timer
- [ ] Implement session reset on disconnect

---

## ENCRYPTED MESSAGING

- [ ] Implement AES-GCM encryption service
- [ ] Generate unique nonce per message
- [ ] Implement nonce tracking to prevent replay
- [ ] Validate timestamp tolerance window
- [ ] Implement message packet schema validation
- [ ] Implement encrypted message send
- [ ] Implement encrypted message receive
- [ ] Implement message acknowledgment logic

---

## SECURITY HARDENING (PHASE 2)

- [ ] Add long-term device identity key pair
- [ ] Sign ephemeral public key
- [ ] Verify signature to mitigate MITM
- [ ] Implement session integrity logging
- [ ] Add failed-handshake rate limiting
- [ ] Add invalid packet detection and rejection

---

## RELIABILITY

- [ ] Heartbeat mechanism
- [ ] Auto-reconnect strategy
- [ ] BLE timeout handling
- [ ] Graceful session teardown

---

## TESTING & VALIDATION

- [ ] Simulate replay attack
- [ ] Simulate invalid public key
- [ ] Simulate corrupted ciphertext
- [ ] Simulate forced disconnection during handshake
- [ ] Validate session expiration behavior
