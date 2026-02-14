# BlueTalk Architecture (Flutter + BLE)

## System Type

Offline-first BLE encrypted messaging system.

## Communication Protocol

Service UUID:
BlueTalk Primary Service

Characteristics:

- Handshake Characteristic
- Message Characteristic
- Acknowledgment Characteristic

---

## Secure Handshake Flow

1. Device A connects to Device B
2. Exchange public keys (ECDH)
3. Derive shared secret
4. Generate symmetric AES session key
5. Confirm session activation

---

## Message Packet Structure

{
sessionId: UUID,
timestamp: int,
nonce: bytes,
cipherText: bytes,
mac: bytes
}

---

## Risk Considerations

- BLE MTU size limitation
- Packet fragmentation
- OS background restrictions
- Permission denial
- MITM attacks
- Battery drain from continuous scanning

---

## Future Evolution

- Mesh relay system
- Multi-peer group chat
- QR code secure pairing
- Ephemeral session mode
- Secure file transfer
