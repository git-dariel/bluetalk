# QA Agent – BlueTalk (Flutter)

## Transport Testing

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

## Current Assigned Backlog

- Validate replay, invalid key, corrupted ciphertext, and forced-disconnect scenarios.
- Validate session expiration and timeout behavior.
- Verify all failures return structured error states.
