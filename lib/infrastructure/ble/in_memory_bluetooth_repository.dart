import 'dart:async';

import '../../domain/entities/encrypted_message_packet.dart';
import '../../domain/entities/handshake_models.dart';
import '../../domain/repositories/bluetooth_repository.dart';

class InMemoryBluetoothRepository implements BluetoothRepository {
  final StreamController<EncryptedMessagePacket> _inboundController =
      StreamController<EncryptedMessagePacket>.broadcast();
  final StreamController<String> _ackController =
      StreamController<String>.broadcast();

  bool _connected = false;

  @override
  Stream<String> get acknowledgments => _ackController.stream;

  @override
  Stream<EncryptedMessagePacket> get inboundMessages => _inboundController.stream;

  @override
  Future<void> connect() async {
    _connected = true;
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }

  @override
  Future<void> sendHandshake(HandshakePublicKeyPacket packet) async {
    if (!_connected) {
      throw StateError('BLE not connected');
    }
    if (packet.publicKey.isEmpty) {
      throw StateError('Invalid public key');
    }
  }

  @override
  Future<void> sendHandshakeConfirmation(HandshakeConfirmPacket packet) async {
    if (!_connected) {
      throw StateError('BLE not connected');
    }
    if (packet.mac.isEmpty) {
      throw StateError('Invalid handshake confirmation');
    }
  }

  @override
  Future<void> sendMessage(EncryptedMessagePacket packet) async {
    if (!_connected) {
      throw StateError('BLE not connected');
    }
    await Future<void>.delayed(const Duration(milliseconds: 30));
    _inboundController.add(packet);
    _ackController.add(packet.messageId);
  }
}
