import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DiscoveredPeer {
  const DiscoveredPeer({
    required this.id,
    required this.name,
    required this.rssi,
  });

  final String id;
  final String name;
  final int rssi;
}

class NearbyUserDiscoveryService {
  final StreamController<List<DiscoveredPeer>> _peersController =
      StreamController<List<DiscoveredPeer>>.broadcast();

  StreamSubscription<List<ScanResult>>? _scanSub;

  Stream<List<DiscoveredPeer>> get peers => _peersController.stream;

  Future<void> start() async {
    await stop();
    await _ensureBluetoothAdapterOn();
    _scanSub = FlutterBluePlus.scanResults.listen(_onScanResults);
    await FlutterBluePlus.startScan(
      androidUsesFineLocation: true,
      androidCheckLocationServices: true,
    );
  }

  Future<void> stop() async {
    await _scanSub?.cancel();
    _scanSub = null;
    await FlutterBluePlus.stopScan();
  }

  Future<void> dispose() async {
    await stop();
    await _peersController.close();
  }

  Future<void> _ensureBluetoothAdapterOn() async {
    final bool supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      throw StateError('Bluetooth is not supported on this device.');
    }

    BluetoothAdapterState state = FlutterBluePlus.adapterStateNow;
    if (state == BluetoothAdapterState.unknown) {
      state = await FlutterBluePlus.adapterState.first;
    }

    if (state == BluetoothAdapterState.on) {
      return;
    }

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn(timeout: 12);
      return;
    }

    throw StateError('Bluetooth is off. Please turn it on in system settings.');
  }

  void _onScanResults(List<ScanResult> results) {
    final Map<String, DiscoveredPeer> deduped = <String, DiscoveredPeer>{};

    for (final ScanResult result in results) {
      final String id = result.device.remoteId.str;
      final String name = _peerNameFromResult(result, id);

      if (name.isEmpty) {
        continue;
      }

      deduped[id] = DiscoveredPeer(
        id: id,
        name: name,
        rssi: result.rssi,
      );
    }

    final List<DiscoveredPeer> peers = deduped.values.toList()
      ..sort((DiscoveredPeer a, DiscoveredPeer b) => b.rssi.compareTo(a.rssi));

    _peersController.add(peers);
  }

  String _peerNameFromResult(ScanResult result, String id) {
    final String platformName = result.device.platformName.trim();
    if (platformName.isNotEmpty) {
      return platformName;
    }

    final String advName = result.advertisementData.advName.trim();
    if (advName.isNotEmpty) {
      return advName;
    }

    return 'Nearby ${id.substring(0, id.length >= 4 ? 4 : id.length)}';
  }
}
