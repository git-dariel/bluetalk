import 'dart:async';

import '../../core/app_exception.dart';
import '../../domain/entities/encrypted_message_packet.dart';
import '../../domain/repositories/bluetooth_repository.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../../domain/repositories/session_store.dart';
import '../../infrastructure/ble/ble_protocol.dart';

class MessageService {
  MessageService({
    required BluetoothRepository bluetoothRepository,
    required CryptoRepository cryptoRepository,
    required SessionStore sessionStore,
  })  : _bluetoothRepository = bluetoothRepository,
        _cryptoRepository = cryptoRepository,
        _sessionStore = sessionStore;

  final BluetoothRepository _bluetoothRepository;
  final CryptoRepository _cryptoRepository;
  final SessionStore _sessionStore;

  Stream<String> get acknowledgments => _bluetoothRepository.acknowledgments;

  Stream<String> get decryptedInboundMessages =>
      _bluetoothRepository.inboundMessages.asyncMap(_decryptInbound);

  Future<EncryptedMessagePacket> sendEncryptedMessage(String text) async {
    final session = _sessionStore.current;
    if (session == null) {
      throw const AppException('No active session');
    }
    if (session.isExpired) {
      _sessionStore.clear();
      throw const AppException('Session expired');
    }

    final String nonce = _cryptoRepository.generateNonceBase64();
    final bool acceptedNonce = _sessionStore.registerNonce(nonce);
    if (!acceptedNonce) {
      throw const AppException('Duplicate nonce rejected');
    }

    final cipher = await _cryptoRepository.encrypt(
      text: text,
      sessionKey: session.key,
      nonceBase64: nonce,
    );

    final EncryptedMessagePacket packet = EncryptedMessagePacket(
      messageId: DateTime.now().microsecondsSinceEpoch.toString(),
      sessionId: session.id,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      nonce: nonce,
      cipherText: cipher.cipherText,
      mac: cipher.mac,
    );

    if (!packet.isSchemaValid()) {
      throw const AppException('Invalid packet schema');
    }

    await _bluetoothRepository.sendMessage(packet);
    return packet;
  }

  Future<String> _decryptInbound(EncryptedMessagePacket packet) async {
    final session = _sessionStore.current;
    if (session == null || session.isExpired) {
      throw const AppException('No active session for inbound message');
    }

    final DateTime packetTime =
        DateTime.fromMillisecondsSinceEpoch(packet.timestamp);
    final Duration drift = DateTime.now().difference(packetTime).abs();
    if (drift > BleProtocol.messageTolerance) {
      throw const AppException('Rejected message outside timestamp tolerance');
    }

    if (!_sessionStore.registerNonce(packet.nonce)) {
      throw const AppException('Replay attempt detected');
    }

    return _cryptoRepository.decrypt(packet: packet, sessionKey: session.key);
  }
}
