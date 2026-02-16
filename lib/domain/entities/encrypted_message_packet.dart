class EncryptedMessagePacket {
  const EncryptedMessagePacket({
    required this.messageId,
    required this.sessionId,
    required this.timestamp,
    required this.nonce,
    required this.cipherText,
    required this.mac,
  });

  final String messageId;
  final String sessionId;
  final int timestamp;
  final String nonce;
  final String cipherText;
  final String mac;

  Map<String, Object> toMap() {
    return <String, Object>{
      'type': 'message',
      'messageId': messageId,
      'sessionId': sessionId,
      'timestamp': timestamp,
      'nonce': nonce,
      'cipherText': cipherText,
      'mac': mac,
    };
  }

  bool isSchemaValid() {
    return messageId.isNotEmpty &&
        sessionId.isNotEmpty &&
        timestamp > 0 &&
        nonce.isNotEmpty &&
        cipherText.isNotEmpty &&
        mac.isNotEmpty;
  }
}
