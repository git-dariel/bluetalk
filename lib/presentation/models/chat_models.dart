import 'package:flutter/material.dart';

@immutable
class NearbyUser {
  const NearbyUser({
    required this.endpointId,
    required this.name,
    required this.isConnected,
  });

  final String endpointId;
  final String name;
  final bool isConnected;
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
