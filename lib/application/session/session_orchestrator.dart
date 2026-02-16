import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/app_exception.dart';
import '../../domain/entities/handshake_models.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/bluetooth_repository.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../../domain/repositories/session_store.dart';
import '../../infrastructure/ble/ble_protocol.dart';

class SessionOrchestrator {
  SessionOrchestrator({
    required BluetoothRepository bluetoothRepository,
    required CryptoRepository cryptoRepository,
    required SessionStore sessionStore,
  })  : _bluetoothRepository = bluetoothRepository,
        _cryptoRepository = cryptoRepository,
        _sessionStore = sessionStore;

  final BluetoothRepository _bluetoothRepository;
  final CryptoRepository _cryptoRepository;
  final SessionStore _sessionStore;

  Timer? _sessionExpiryTimer;
  final List<DateTime> _handshakeAttempts = <DateTime>[];

  Future<Session> createSecureSession() async {
    _enforceHandshakeRateLimit();
    await _bluetoothRepository.connect();
    _sessionStore.markConnected(true);

    try {
      final IdentityKeyMaterial identity =
          await _cryptoRepository.generateIdentityKeyMaterial();
      final EphemeralKeyMaterial local =
          await _cryptoRepository.generateEphemeralKeyMaterial();
      final EphemeralKeyMaterial remote =
          await _cryptoRepository.generateEphemeralKeyMaterial();

      final String signature = await _cryptoRepository.signPublicKey(
        publicKey: local.public,
        identity: identity,
      );

      final bool validSignature = await _cryptoRepository.verifyPublicKeySignature(
        publicKey: local.public,
        signature: signature,
        identityPublicKey: identity.public,
      );

      if (!validSignature) {
        throw const AppException('Identity signature verification failed');
      }

      final HandshakePublicKeyPacket handshakePacket = HandshakePublicKeyPacket(
        protocolVersion: 1,
        publicKey: _cryptoRepository.publicKeyToBase64(local.public),
        identitySignature: signature,
      );
      await _bluetoothRepository.sendHandshake(handshakePacket);

      final List<int> sharedSecret = await _cryptoRepository.computeSharedSecret(
        local: local,
        remotePublicKey: remote.public,
      );
      final List<int> sessionKey =
          await _cryptoRepository.deriveSessionKey(sharedSecret);
      final String confirmationMac = await _cryptoRepository.handshakeMac(sessionKey);

      await _bluetoothRepository.sendHandshakeConfirmation(
        HandshakeConfirmPacket(mac: confirmationMac),
      );

      final Session session = Session(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        key: sessionKey,
        expiresAt: DateTime.now().add(BleProtocol.sessionTtl),
      );

      _sessionStore.activate(session);
      _resetSessionExpiryTimer(BleProtocol.sessionTtl);
      return session;
    } on UnimplementedError {
      if (kReleaseMode) {
        throw const AppException('Cryptography backend is unavailable');
      }
      return _createDebugFallbackSession();
    }
  }

  Session _createDebugFallbackSession() {
    final Random random = Random.secure();
    final List<int> sessionKey =
        List<int>.generate(32, (_) => random.nextInt(256));
    final Session session = Session(
      id: '${DateTime.now().microsecondsSinceEpoch}-debug',
      key: sessionKey,
      expiresAt: DateTime.now().add(BleProtocol.sessionTtl),
    );
    _sessionStore.activate(session);
    _resetSessionExpiryTimer(BleProtocol.sessionTtl);
    return session;
  }

  void resetSessionOnDisconnect() {
    _sessionExpiryTimer?.cancel();
    _sessionStore.clear();
  }

  void _enforceHandshakeRateLimit() {
    final DateTime now = DateTime.now();
    _handshakeAttempts.removeWhere(
      (DateTime timestamp) =>
          now.difference(timestamp) > const Duration(seconds: 30),
    );
    if (_handshakeAttempts.length >= 5) {
      throw const AppException('Handshake rate limit reached');
    }
    _handshakeAttempts.add(now);
  }

  void _resetSessionExpiryTimer(Duration ttl) {
    _sessionExpiryTimer?.cancel();
    _sessionExpiryTimer = Timer(ttl, () {
      _sessionStore.clear();
    });
  }
}
