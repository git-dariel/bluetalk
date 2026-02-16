import '../entities/encrypted_message_packet.dart';
import '../entities/handshake_models.dart';

abstract class BluetoothRepository {
  Stream<EncryptedMessagePacket> get inboundMessages;
  Stream<String> get acknowledgments;

  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendHandshake(HandshakePublicKeyPacket packet);
  Future<void> sendHandshakeConfirmation(HandshakeConfirmPacket packet);
  Future<void> sendMessage(EncryptedMessagePacket packet);
}
