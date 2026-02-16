import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import '../../domain/entities/encrypted_message_packet.dart';
import '../../domain/repositories/crypto_repository.dart';

class CryptographyRepository implements CryptoRepository {
  CryptographyRepository()
      : _ecdh = Ecdh.p256(length: 256),
        _aes = AesGcm.with256bits(),
        _hmac = Hmac.sha256(),
        _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32),
        _ed25519 = Ed25519();

  final Ecdh _ecdh;
  final AesGcm _aes;
  final Hmac _hmac;
  final Hkdf _hkdf;
  final Ed25519 _ed25519;
  final Random _random = Random.secure();

  @override
  Future<List<int>> computeSharedSecret({
    required EphemeralKeyMaterial local,
    required List<int> remotePublicKey,
  }) async {
    final SimplePublicKey remote = SimplePublicKey(
      remotePublicKey,
      type: KeyPairType.p256,
    );
    final SecretKey secret = await _ecdh.sharedSecretKey(
      keyPair: local.private as KeyPair,
      remotePublicKey: remote,
    );
    return secret.extractBytes();
  }

  @override
  Future<String> decrypt({
    required EncryptedMessagePacket packet,
    required List<int> sessionKey,
  }) async {
    final SecretBox box = SecretBox(
      base64Decode(packet.cipherText),
      nonce: base64Decode(packet.nonce),
      mac: Mac(base64Decode(packet.mac)),
    );
    final List<int> clear = await _aes.decrypt(
      box,
      secretKey: SecretKey(sessionKey),
    );
    return utf8.decode(clear);
  }

  @override
  Future<List<int>> deriveSessionKey(List<int> sharedSecret) async {
    final SecretKey key = await _hkdf.deriveKey(
      secretKey: SecretKey(sharedSecret),
      info: utf8.encode('BlueTalk Session Key'),
      nonce: utf8.encode('BlueTalk Salt v1'),
    );
    return key.extractBytes();
  }

  @override
  Future<EncryptedCipher> encrypt({
    required String text,
    required List<int> sessionKey,
    required String nonceBase64,
  }) async {
    final SecretBox box = await _aes.encrypt(
      utf8.encode(text),
      secretKey: SecretKey(sessionKey),
      nonce: base64Decode(nonceBase64),
    );
    return EncryptedCipher(
      cipherText: base64Encode(box.cipherText),
      mac: base64Encode(box.mac.bytes),
    );
  }

  @override
  Future<EphemeralKeyMaterial> generateEphemeralKeyMaterial() async {
    final KeyPair pair = await _ecdh.newKeyPair();
    final SimplePublicKey public =
        await pair.extractPublicKey() as SimplePublicKey;
    return EphemeralKeyMaterial(private: pair, public: public.bytes);
  }

  @override
  String generateNonceBase64() {
    final List<int> bytes = List<int>.generate(12, (_) => _random.nextInt(256));
    return base64Encode(bytes);
  }

  @override
  Future<IdentityKeyMaterial> generateIdentityKeyMaterial() async {
    final KeyPair pair = await _ed25519.newKeyPair();
    final SimplePublicKey public =
        await pair.extractPublicKey() as SimplePublicKey;
    return IdentityKeyMaterial(private: pair, public: public.bytes);
  }

  @override
  Future<String> handshakeMac(List<int> sessionKey) async {
    final Mac mac = await _hmac.calculateMac(
      utf8.encode('session-confirm'),
      secretKey: SecretKey(sessionKey),
    );
    return base64Encode(mac.bytes);
  }

  @override
  List<int> publicKeyFromBase64(String value) {
    return base64Decode(value);
  }

  @override
  String publicKeyToBase64(List<int> publicKey) {
    return base64Encode(publicKey);
  }

  @override
  Future<String> signPublicKey({
    required List<int> publicKey,
    required IdentityKeyMaterial identity,
  }) async {
    final Signature signature = await _ed25519.sign(
      publicKey,
      keyPair: identity.private as KeyPair,
    );
    return base64Encode(signature.bytes);
  }

  @override
  Future<bool> verifyPublicKeySignature({
    required List<int> publicKey,
    required String signature,
    required List<int> identityPublicKey,
  }) async {
    return _ed25519.verify(
      publicKey,
      signature: Signature(
        base64Decode(signature),
        publicKey: SimplePublicKey(identityPublicKey, type: KeyPairType.ed25519),
      ),
    );
  }
}
