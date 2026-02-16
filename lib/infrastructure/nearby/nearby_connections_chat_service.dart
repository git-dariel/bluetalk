import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:nearby_connections/nearby_connections.dart';

/// Discovered endpoint from Nearby Connections.
class DiscoveredEndpoint {
  const DiscoveredEndpoint({required this.id, required this.name});

  final String id;
  final String name;
}

/// Incoming chat message from a connected peer.
class IncomingChatMessage {
  const IncomingChatMessage({
    required this.endpointId,
    required this.text,
  });

  final String endpointId;
  final String text;
}

/// Service that uses Google Nearby Connections API for
/// device-to-device discovery, connection, and messaging.
///
/// Replaces both NearbyUserDiscoveryService (BLE scanning)
/// and InMemoryBluetoothRepository (transport).
class NearbyConnectionsChatService {
  NearbyConnectionsChatService({required String username})
      : _username = username;

  static const String _serviceId = 'com.bluetalk.nearby';
  static const Strategy _strategy = Strategy.P2P_CLUSTER;

  String _username;

  // ---- Discovery state ----
  final Map<String, DiscoveredEndpoint> _endpoints =
      <String, DiscoveredEndpoint>{};

  final StreamController<List<DiscoveredEndpoint>> _endpointsController =
      StreamController<List<DiscoveredEndpoint>>.broadcast();

  Stream<List<DiscoveredEndpoint>> get discoveredEndpoints =>
      _endpointsController.stream;

  List<DiscoveredEndpoint> get currentEndpoints =>
      List<DiscoveredEndpoint>.unmodifiable(_endpoints.values.toList());

  // ---- Connection state ----
  final Map<String, String> _connectedPeers = <String, String>{};
  final StreamController<Map<String, String>> _connectionController =
      StreamController<Map<String, String>>.broadcast();

  Stream<Map<String, String>> get connections => _connectionController.stream;

  bool isConnectedTo(String endpointId) =>
      _connectedPeers.containsKey(endpointId);

  bool get hasAnyConnection => _connectedPeers.isNotEmpty;

  String? endpointIdForName(String name) {
    for (final MapEntry<String, String> entry in _connectedPeers.entries) {
      if (entry.value == name) {
        return entry.key;
      }
    }
    return null;
  }

  // ---- Messaging ----
  final StreamController<IncomingChatMessage> _incomingController =
      StreamController<IncomingChatMessage>.broadcast();

  Stream<IncomingChatMessage> get incomingMessages =>
      _incomingController.stream;

  // ---- Username ----
  void updateUsername(String name) {
    _username = name;
  }

  // ---- Permissions ----
  /// Permissions are handled by BluetoothPermissionService before this
  /// service starts. This is a no-op placeholder for compatibility.
  Future<bool> ensurePermissions() async {
    // All BLE, location, and WiFi permissions are requested by
    // BluetoothPermissionService.requestBluetoothPermissions().
    return true;
  }

  // ---- Start advertising + discovery ----
  Future<void> start() async {
    await stop();

    try {
      await Nearby().startAdvertising(
        _username,
        _strategy,
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: _onConnectionResult,
        onDisconnected: _onDisconnected,
        serviceId: _serviceId,
      );
    } catch (_) {
      // May fail if already advertising; continue to discovery.
    }

    try {
      await Nearby().startDiscovery(
        _username,
        _strategy,
        onEndpointFound: _onEndpointFound,
        onEndpointLost: _onEndpointLost,
        serviceId: _serviceId,
      );
    } catch (_) {
      // May fail if already discovering; that's OK.
    }
  }

  // ---- Stop advertising + discovery ----
  Future<void> stop() async {
    try {
      await Nearby().stopAdvertising();
    } catch (_) {}
    try {
      await Nearby().stopDiscovery();
    } catch (_) {}
    _endpoints.clear();
    _emitEndpoints();
  }

  // ---- Request connection to a discovered peer ----
  Future<void> connectToPeer(String endpointId) async {
    await Nearby().requestConnection(
      _username,
      endpointId,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );
  }

  // ---- Disconnect from a specific peer ----
  Future<void> disconnectFromPeer(String endpointId) async {
    try {
      await Nearby().disconnectFromEndpoint(endpointId);
    } catch (_) {}
    _connectedPeers.remove(endpointId);
    _connectionController.add(Map<String, String>.from(_connectedPeers));
  }

  // ---- Send a text message to a connected peer ----
  Future<void> sendMessage(String endpointId, String text) async {
    if (!_connectedPeers.containsKey(endpointId)) {
      throw StateError('Not connected to endpoint $endpointId');
    }

    final Map<String, String> payload = <String, String>{
      'type': 'chat',
      'text': text,
      'sender': _username,
      'ts': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final Uint8List bytes =
        Uint8List.fromList(utf8.encode(json.encode(payload)));
    await Nearby().sendBytesPayload(endpointId, bytes);
  }

  // ---- Lifecycle ----
  Future<void> dispose() async {
    await stop();
    for (final String id in _connectedPeers.keys.toList()) {
      try {
        await Nearby().disconnectFromEndpoint(id);
      } catch (_) {}
    }
    try {
      await Nearby().stopAllEndpoints();
    } catch (_) {}
    await _endpointsController.close();
    await _incomingController.close();
    await _connectionController.close();
  }

  // ---- Nearby Connections callbacks ----

  void _onEndpointFound(String id, String userName, String serviceId) {
    _endpoints[id] = DiscoveredEndpoint(id: id, name: userName);
    _emitEndpoints();
  }

  void _onEndpointLost(String? id) {
    if (id != null) {
      _endpoints.remove(id);
      _emitEndpoints();
    }
  }

  void _onConnectionInitiated(String id, ConnectionInfo info) {
    // Auto-accept all incoming connections from other bluetalk users.
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: _onPayloadReceived,
      onPayloadTransferUpdate: _onPayloadTransferUpdate,
    );

    // Track the peer name from connection info so we know who connected.
    _connectedPeers[id] = info.endpointName;
    _connectionController.add(Map<String, String>.from(_connectedPeers));
  }

  void _onConnectionResult(String id, Status status) {
    if (status == Status.CONNECTED) {
      // Already tracked in _onConnectionInitiated; remove from discovered list.
      _endpoints.remove(id);
      _emitEndpoints();
    } else {
      // Connection rejected or error — remove from connected peers.
      _connectedPeers.remove(id);
      _connectionController.add(Map<String, String>.from(_connectedPeers));
    }
  }

  void _onDisconnected(String id) {
    _connectedPeers.remove(id);
    _connectionController.add(Map<String, String>.from(_connectedPeers));
  }

  void _onPayloadReceived(String endpointId, Payload payload) {
    if (payload.type != PayloadType.BYTES || payload.bytes == null) {
      return;
    }

    try {
      final String jsonStr = utf8.decode(payload.bytes!);
      final Map<String, dynamic> data =
          json.decode(jsonStr) as Map<String, dynamic>;

      if (data['type'] == 'chat') {
        _incomingController.add(
          IncomingChatMessage(
            endpointId: endpointId,
            text: (data['text'] as String?) ?? '',
          ),
        );
      }
    } catch (_) {
      // Malformed payload — ignore.
    }
  }

  void _onPayloadTransferUpdate(
      String endpointId, PayloadTransferUpdate update) {
    // Could track payload delivery status here if needed.
  }

  void _emitEndpoints() {
    _endpointsController.add(
      List<DiscoveredEndpoint>.unmodifiable(_endpoints.values.toList()),
    );
  }
}
