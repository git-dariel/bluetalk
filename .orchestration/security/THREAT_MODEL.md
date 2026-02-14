# BlueTalk Threat Model

Version: 1.0

---

1. SYSTEM CONTEXT

---

BlueTalk enables encrypted BLE communication between nearby devices.

Assets to Protect:

- Message content
- Session keys
- Device identity
- Communication metadata

---

2. ATTACK SURFACE

---

- BLE radio channel
- Handshake phase
- Message transmission
- Session storage
- Fragmentation handling

---

3. THREAT ACTORS

---

1. Passive Eavesdropper
   - Can sniff BLE packets
   - Cannot modify packets

2. Active Attacker
   - Can inject packets
   - Can replay packets
   - Can attempt MITM

3. Malicious Peer
   - Connects but sends malformed data

---

4. IDENTIFIED THREATS & MITIGATIONS

---

THREAT: Passive Sniffing
RISK: Message disclosure
MITIGATION:

- AES-GCM encryption
- ECDH shared secret
- Forward secrecy

---

THREAT: Replay Attack
RISK: Message duplication or state corruption
MITIGATION:

- Unique nonce per message
- Nonce cache
- Timestamp validation

---

THREAT: Man-in-the-Middle (MITM)
RISK: Key substitution during handshake
MITIGATION (Current Phase):

- Session confirmation HMAC

MITIGATION (Future Phase):

- Long-term identity key pair
- Sign ephemeral public key
- Signature verification

---

THREAT: Message Tampering
RISK: Modified message contents
MITIGATION:

- AES-GCM authentication tag
- Reject invalid MAC

---

THREAT: Fragment Manipulation
RISK: Corrupted reassembly
MITIGATION:

- Validate fragment count
- Reject incomplete sets
- Decrypt only after full reassembly

---

THREAT: Resource Exhaustion
RISK: BLE spam or handshake flooding
MITIGATION:

- Rate limiting handshake attempts
- Disconnect invalid peers
- Session timeout enforcement

---

5. OUT-OF-SCOPE

---

- Physical device compromise
- OS-level root attacks
- Nation-state adversaries

---

6. SECURITY LEVEL SUMMARY

---

Current Level:

- Confidential against passive attacker
- Resistant to replay
- Partial MITM protection

Future Upgrade:

- Full MITM resistance via identity signing
