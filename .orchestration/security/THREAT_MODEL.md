# BlueTalk Threat Model

Version: 1.0

---

1. SYSTEM CONTEXT

---

BlueTalk enables nearby communication between nearby devices, with encrypted transport as the target state.

Assets to Protect:

- Message content
- Session keys
- Device identity
- Communication metadata

---

2. ATTACK SURFACE

---

- Nearby transport channel (discovery + data)
- Handshake phase
- Message transmission
- Session storage
- Fragmentation handling

---

3. THREAT ACTORS

---

1. Passive Eavesdropper
   - Can sniff wireless packets
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
RISK: discovery spam or handshake flooding
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

- Real-time nearby transport operational
- Security hardening in progress
- Encrypted transport not yet enforced end-to-end

Future Upgrade:

- Confidential transport via AES-GCM
- Replay resistance via nonce tracking
- Full MITM resistance via identity signing
