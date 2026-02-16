import 'dart:async';

import '../../domain/repositories/bluetooth_repository.dart';
import '../../domain/repositories/session_store.dart';

class ReliabilityService {
  ReliabilityService({
    required BluetoothRepository bluetoothRepository,
    required SessionStore sessionStore,
  })  : _bluetoothRepository = bluetoothRepository,
        _sessionStore = sessionStore;

  final BluetoothRepository _bluetoothRepository;
  final SessionStore _sessionStore;

  Timer? _heartbeatTimer;

  void startHeartbeat({Duration interval = const Duration(seconds: 12)}) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(interval, (_) {
      if (!_sessionStore.isConnected) {
        _heartbeatTimer?.cancel();
      }
    });
  }

  Future<void> handleTimeoutAndReconnect({int maxAttempts = 3}) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        await _bluetoothRepository.connect();
        _sessionStore.markConnected(true);
        return;
      } catch (_) {
        await Future<void>.delayed(Duration(milliseconds: 300 * attempt));
      }
    }
    _sessionStore.markConnected(false);
  }

  Future<void> gracefulTeardown() async {
    _heartbeatTimer?.cancel();
    await _bluetoothRepository.disconnect();
    _sessionStore.clear();
  }
}
