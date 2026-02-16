class HandshakePublicKeyPacket {
  const HandshakePublicKeyPacket({
    required this.protocolVersion,
    required this.publicKey,
    required this.identitySignature,
  });

  final int protocolVersion;
  final String publicKey;
  final String identitySignature;
}

class HandshakeConfirmPacket {
  const HandshakeConfirmPacket({required this.mac});

  final String mac;
}
