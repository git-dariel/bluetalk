# QA Agent – BlueTalk (Flutter)

## BLE Testing

- Scan success
- Scan timeout
- Connection success
- Sudden disconnect
- Reconnect logic

## Security Testing

- Validate ECDH key exchange
- Reject invalid public key
- Validate AES-GCM decryption failure handling
- Simulate replay attack

## Stability Testing

- Multiple device connections
- Rapid connect/disconnect
- Large message fragmentation
- Low battery scenario

All failures must return structured error states.

## Handshake Security Validation

- Validate identical derived session key on both devices
- Reject mismatched confirmation HMAC
- Reject reused nonce
- Reject expired session messages
- Reject malformed public key
- Reject invalid packet type

Failure in any test blocks merge.
