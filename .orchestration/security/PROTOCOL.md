# BlueTalk BLE Communication Protocol Specification

Version: 1.0
Status: Draft

---

1. OVERVIEW

---

BlueTalk is a peer-to-peer encrypted messaging protocol over BLE.

Security Goals:

- Confidentiality
- Integrity
- Forward Secrecy
- Replay Protection

Transport:

- Bluetooth Low Energy (BLE)
- GATT-based communication

---

2. BLE SERVICE DEFINITION

---

Primary Service UUID:

- BlueTalk Service UUID (to be defined)

Characteristics:

1. Handshake Characteristic
   - Used for key exchange and session negotiation
   - Write + Notify

2. Message Characteristic
   - Used for encrypted message transfer
   - Write + Notify

3. Acknowledgment Characteristic
   - Used for delivery confirmation
   - Write

---

3. HANDSHAKE PROTOCOL

---

Step 1: Public Key Exchange

Each device:

- Generates ephemeral ECDH P-256 key pair
- Sends public key

Packet:

{
"type": "handshake_public_key",
"protocolVersion": 1,
"publicKey": "<base64>"
}

Step 2: Shared Secret Computation

Both devices compute:
sharedSecret = ECDH(privateKey, remotePublicKey)

Step 3: Session Key Derivation

sessionKey = HKDF-SHA256(sharedSecret, "BlueTalk Session Key")

Step 4: Session Confirmation

Each device sends:

{
"type": "handshake_confirm",
"mac": HMAC(sessionKey, "session-confirm")
}

If confirmation MACs match:

- Session becomes ACTIVE
  Else:
- Terminate connection

---

4. MESSAGE PROTOCOL

---

All messages MUST be encrypted using AES-GCM-256.

Message Packet:

{
"type": "message",
"sessionId": "<uuid>",
"timestamp": <unix_epoch>,
"nonce": "<base64>",
"cipherText": "<base64>",
"mac": "<base64>"
}

Rules:

- Nonce must be unique per message
- Timestamp must be within tolerance window (e.g., 30 seconds)
- Reject duplicate nonce
- Reject invalid MAC

---

5. MTU & FRAGMENTATION

---

BLE MTU limits message size.

If encrypted payload > MTU:

- Split into numbered fragments
- Include:
  fragmentIndex
  totalFragments
  messageId

All fragments must be received before decryption.

---

6. SESSION RULES

---

- Session keys stored in memory only
- Session expires after configurable timeout
- New handshake required after disconnect
- No plaintext fallback allowed

---

7. FUTURE EXTENSIONS

---

- Device identity signing
- QR-based pairing
- Group key negotiation
- Mesh relay protocol
