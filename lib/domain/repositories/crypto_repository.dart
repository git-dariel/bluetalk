import '../../domain/entities/encrypted_message_packet.dart';

abstract class CryptoRepository {
  Future<EphemeralKeyMaterial> generateEphemeralKeyMaterial();
  Future<IdentityKeyMaterial> generateIdentityKeyMaterial();
  Future<String> signPublicKey({
    required List<int> publicKey,
    required IdentityKeyMaterial identity,
  });
  Future<bool> verifyPublicKeySignature({
    required List<int> publicKey,
    required String signature,
    required List<int> identityPublicKey,
  });
  Future<List<int>> computeSharedSecret({
    required EphemeralKeyMaterial local,
    required List<int> remotePublicKey,
  });
  Future<List<int>> deriveSessionKey(List<int> sharedSecret);
  Future<String> handshakeMac(List<int> sessionKey);
  String publicKeyToBase64(List<int> publicKey);
  List<int> publicKeyFromBase64(String value);
  String generateNonceBase64();
  Future<EncryptedCipher> encrypt({
    required String text,
    required List<int> sessionKey,
    required String nonceBase64,
  });
  Future<String> decrypt({
    required EncryptedMessagePacket packet,
    required List<int> sessionKey,
  });
}

class EphemeralKeyMaterial {
  const EphemeralKeyMaterial({
    required this.private,
    required this.public,
  });

  final Object private;
  final List<int> public;
}

class IdentityKeyMaterial {
  const IdentityKeyMaterial({
    required this.private,
    required this.public,
  });

  final Object private;
  final List<int> public;
}

class EncryptedCipher {
  const EncryptedCipher({
    required this.cipherText,
    required this.mac,
  });

  final String cipherText;
  final String mac;
}
