import 'package:flutter/material.dart';

@immutable
class NearbyUser {
  const NearbyUser({
    required this.endpointId,
    required this.name,
    required this.isConnected,
    this.isConnecting = false,
  });

  final String endpointId;
  final String name;
  final bool isConnected;

  /// True while the outgoing connection attempt is in-flight.
  final bool isConnecting;
}

@immutable
class ChatThread {
  const ChatThread({
    required this.name,
    required this.preview,
    required this.isActive,
  });

  final String name;
  final String preview;
  final bool isActive;
}

@immutable
class ChatMessage {
  const ChatMessage({required this.text, required this.fromMe});

  final String text;
  final bool fromMe;
}
