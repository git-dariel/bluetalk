class BleProtocol {
  static const String serviceUuid = 'a4d99f14-8cf8-4634-bdb3-14ab0ef5f1a1';
  static const String handshakeCharacteristicUuid =
      'f85e5e95-3848-4f91-b5b1-18fe2f0e1f40';
  static const String messageCharacteristicUuid =
      'd2847c4b-fc5d-4ae9-8f35-a8e7a4bbf248';
  static const String acknowledgmentCharacteristicUuid =
      '6c168cf0-866f-47cc-8d99-b5f5f631113a';
  static const int mtuSafePayloadBytes = 160;
  static const Duration messageTolerance = Duration(seconds: 30);
  static const Duration sessionTtl = Duration(minutes: 15);
  static const Duration handshakeTimeout = Duration(seconds: 6);
}
