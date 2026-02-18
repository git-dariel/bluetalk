# BlueTalk Nearby Communication Protocol Specification

Version: 1.0
Status: Draft

Implementation Note:

- This document specifies the target encrypted protocol.
- Current production transport uses Nearby byte payload messaging while encryption re-integration is in progress.

---

1. OVERVIEW

---

BlueTalk targets peer-to-peer encrypted messaging over Google Nearby Connections.

Security Goals:

- Confidentiality
- Integrity
- Forward Secrecy
- Replay Protection

Transport:

- Nearby Connections API
- Device-to-device byte payload messaging

---

2. TRANSPORT DEFINITION

---

Service ID:

- `com.bluetalk.nearby`

Payload Channels:

1. Handshake payload
   - Used for key exchange and session negotiation

2. Message payload
   - Used for encrypted message transfer

3. Acknowledgment payload
   - Used for delivery confirmation

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

All messages in the target protocol MUST be encrypted using AES-GCM-256.

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

5. PAYLOAD SIZE & CHUNKING

---

Nearby payload size and transfer conditions can vary by device and channel.

If encrypted payload exceeds the safe payload threshold:

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
- No plaintext fallback allowed in final enforced mode

---

7. FUTURE EXTENSIONS

---

- Device identity signing
- QR-based pairing
- Group key negotiation
- Mesh relay protocol
