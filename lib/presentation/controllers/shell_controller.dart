import 'dart:async';

import 'package:flutter/material.dart';

import '../../infrastructure/ble/bluetooth_permission_service.dart';
import '../../infrastructure/nearby/nearby_connections_chat_service.dart';
import '../models/chat_models.dart';

class ShellController extends ChangeNotifier {
  ShellController({
    required BluetoothPermissionService permissionService,
    required NearbyConnectionsChatService chatService,
  })  : _permissionService = permissionService,
        _chatService = chatService;

  final BluetoothPermissionService _permissionService;
  final NearbyConnectionsChatService _chatService;

  int _tabIndex = 0;
  bool _scanEnabled = false;
  String _username = 'BlueTalk User';
  String? _activeThreadName;
  String? _statusMessage;

  final List<NearbyUser> _nearbyUsers = <NearbyUser>[];
  final Map<String, List<ChatMessage>> _messagesByThread =
      <String, List<ChatMessage>>{};

  /// Maps thread name to Nearby Connections endpoint ID.
  final Map<String, String> _threadEndpointMap = <String, String>{};

  StreamSubscription<List<DiscoveredEndpoint>>? _discoverySubscription;
  StreamSubscription<IncomingChatMessage>? _incomingSubscription;
  StreamSubscription<Map<String, String>>? _connectionSubscription;

  int get tabIndex => _tabIndex;
  bool get scanEnabled => _scanEnabled;
  String get username => _username;
  String? get statusMessage => _statusMessage;

  List<NearbyUser> get nearbyUsers =>
      List<NearbyUser>.unmodifiable(_nearbyUsers);

  List<ChatThread> get threads {
    final List<ChatThread> value = _messagesByThread.entries
        .map(
          (MapEntry<String, List<ChatMessage>> entry) => ChatThread(
            name: entry.key,
            preview: entry.value.isEmpty
                ? 'Say hi to start chatting.'
                : entry.value.last.text,
            isActive: entry.key == _activeThreadName,
          ),
        )
        .toList();

    value.sort((ChatThread a, ChatThread b) => a.name.compareTo(b.name));
    return List<ChatThread>.unmodifiable(value);
  }

  List<ChatMessage> messagesForThread(String threadName) {
    final List<ChatMessage> messages =
        _messagesByThread[threadName] ?? <ChatMessage>[];
    return List<ChatMessage>.unmodifiable(messages);
  }

  Future<bool> requestPermissionAndStart() async {
    final bool granted = await _permissionService.requestBluetoothPermissions();
    if (!granted) {
      _statusMessage = 'Bluetooth permission denied.';
      notifyListeners();
      return false;
    }

    _statusMessage = null;

    try {
      await _chatService.ensurePermissions();

      // Listen for discovered endpoints.
      _discoverySubscription ??=
          _chatService.discoveredEndpoints.listen(_onEndpointsFound);

      // Listen for incoming messages.
      _incomingSubscription ??=
          _chatService.incomingMessages.listen(_handleIncomingMessage);

      // Listen for connection state changes.
      _connectionSubscription ??=
          _chatService.connections.listen(_onConnectionStateChanged);

      _scanEnabled = true;
      notifyListeners();

      try {
        await _chatService.start();
      } catch (_) {
        _scanEnabled = false;
        _statusMessage =
            'Bluetooth is enabled, but scanning could not start right now.';
        notifyListeners();
      }

      return true;
    } catch (_) {
      _statusMessage = 'Failed to start Nearby Connections.';
      notifyListeners();
      return false;
    }
  }

  void setTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void setScanEnabled(bool value) {
    _scanEnabled = value;
    if (!value) {
      _statusMessage = null;
    }
    notifyListeners();

    if (value) {
      unawaited(_startScanFromToggle());
    } else {
      unawaited(_stopScan());
    }
  }

  void updateUsername(String value) {
    if (value.trim().isEmpty) {
      return;
    }
    _username = value.trim();
    _chatService.updateUsername(_username);
    notifyListeners();
  }

  void setActiveThread(String threadName) {
    _activeThreadName = threadName;
    _messagesByThread.putIfAbsent(threadName, () => <ChatMessage>[]);
    notifyListeners();
  }

  /// Connect to a discovered peer and open a chat thread.
  Future<void> connectToUser(NearbyUser user) async {
    if (user.isConnected) {
      return;
    }

    try {
      await _chatService.connectToPeer(user.endpointId);
      _statusMessage = 'Connecting to ${user.name}...';
      notifyListeners();
    } catch (_) {
      _statusMessage = 'Could not connect to ${user.name}.';
      notifyListeners();
    }
  }

  Future<void> sendMessageToThread(String threadName, String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    _messagesByThread.putIfAbsent(threadName, () => <ChatMessage>[]);
    _messagesByThread[threadName]!
        .add(ChatMessage(text: trimmed, fromMe: true));
    notifyListeners();

    final String? endpointId = _threadEndpointMap[threadName];
    if (endpointId == null || !_chatService.isConnectedTo(endpointId)) {
      _messagesByThread[threadName]!.add(
        const ChatMessage(
          text: 'Not connected to this user. Tap them in Nearby to connect.',
          fromMe: false,
        ),
      );
      notifyListeners();
      return;
    }

    try {
      await _chatService.sendMessage(endpointId, trimmed);
    } catch (_) {
      _messagesByThread[threadName]!.add(
        const ChatMessage(
          text: 'Message could not be delivered. Please retry.',
          fromMe: false,
        ),
      );
      notifyListeners();
    }
  }

  void clearChatHistory() {
    _messagesByThread.clear();
    _activeThreadName = null;
    notifyListeners();
  }

  // ---- Private helpers ----

  Future<void> _startScanFromToggle() async {
    try {
      await _chatService.start();
      _statusMessage = null;
      notifyListeners();
    } catch (_) {
      _scanEnabled = false;
      _statusMessage =
          'Bluetooth is off or unavailable. Please turn it on, then try scan again.';
      notifyListeners();
    }
  }

  Future<void> _stopScan() async {
    await _chatService.stop();
    _nearbyUsers.clear();
    notifyListeners();
  }

  void _onEndpointsFound(List<DiscoveredEndpoint> endpoints) {
    _nearbyUsers
      ..clear()
      ..addAll(
        endpoints.map(
          (DiscoveredEndpoint ep) => NearbyUser(
            endpointId: ep.id,
            name: ep.name,
            isConnected: _chatService.isConnectedTo(ep.id),
          ),
        ),
      );
    notifyListeners();
  }

  void _onConnectionStateChanged(Map<String, String> connectedPeers) {
    // Update the endpoint map for connected peers.
    for (final MapEntry<String, String> entry in connectedPeers.entries) {
      _threadEndpointMap[entry.value] = entry.key;

      // Auto-create a chat thread for newly connected peers.
      _messagesByThread.putIfAbsent(entry.value, () {
        return <ChatMessage>[
          ChatMessage(
            text: 'Connected to ${entry.value}! Say hi.',
            fromMe: false,
          ),
        ];
      });
    }

    // Refresh nearby list with updated connection status.
    _nearbyUsers.clear();
    for (final DiscoveredEndpoint ep in _chatService.currentEndpoints) {
      _nearbyUsers.add(
        NearbyUser(
          endpointId: ep.id,
          name: ep.name,
          isConnected: _chatService.isConnectedTo(ep.id),
        ),
      );
    }

    // Also add connected peers no longer in the discovered list.
    for (final MapEntry<String, String> entry in connectedPeers.entries) {
      final bool alreadyListed =
          _nearbyUsers.any((NearbyUser u) => u.endpointId == entry.key);
      if (!alreadyListed) {
        _nearbyUsers.add(
          NearbyUser(
            endpointId: entry.key,
            name: entry.value,
            isConnected: true,
          ),
        );
      }
    }

    _statusMessage = null;
    notifyListeners();
  }

  void _handleIncomingMessage(IncomingChatMessage msg) {
    // Find the thread name for this endpoint.
    String? threadName;
    for (final MapEntry<String, String> entry in _threadEndpointMap.entries) {
      if (entry.value == msg.endpointId) {
        threadName = entry.key;
        break;
      }
    }

    // Fallback: look up the peer name from connected peers.
    threadName ??= msg.endpointId;
    for (final NearbyUser user in _nearbyUsers) {
      if (user.endpointId == msg.endpointId) {
        threadName = user.name;
        break;
      }
    }

    _messagesByThread.putIfAbsent(threadName!, () => <ChatMessage>[]);
    _messagesByThread[threadName]!.add(
      ChatMessage(text: msg.text, fromMe: false),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_discoverySubscription?.cancel());
    unawaited(_incomingSubscription?.cancel());
    unawaited(_connectionSubscription?.cancel());
    unawaited(_chatService.dispose());
    super.dispose();
  }
}
