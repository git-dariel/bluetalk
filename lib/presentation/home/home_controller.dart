import 'dart:async';

import '../../application/messaging/message_service.dart';
import '../../application/reliability/reliability_service.dart';
import '../../application/session/session_orchestrator.dart';

class HomeController {
  HomeController({
    required SessionOrchestrator sessionOrchestrator,
    required MessageService messageService,
    required ReliabilityService reliabilityService,
  })  : _sessionOrchestrator = sessionOrchestrator,
        _messageService = messageService,
        _reliabilityService = reliabilityService;

  final SessionOrchestrator _sessionOrchestrator;
  final MessageService _messageService;
  final ReliabilityService _reliabilityService;

  final List<String> _logs = <String>[];
  StreamSubscription<String>? _messageSub;
  StreamSubscription<String>? _ackSub;

  List<String> get logs => List<String>.unmodifiable(_logs);

  void addLog(String entry) {
    _logs.insert(0, entry);
  }

  Future<void> initialize() async {
    _messageSub = _messageService.decryptedInboundMessages.listen(
      (String value) {
        _logs.insert(0, 'Inbound: $value');
      },
      onError: (Object error) {
        _logs.insert(0, 'Inbound rejected: $error');
      },
    );
    _ackSub = _messageService.acknowledgments.listen((String messageId) {
      _logs.insert(0, 'Ack: $messageId');
    });
  }

  Future<void> startSession() async {
    final session = await _sessionOrchestrator.createSecureSession();
    _logs.insert(0, 'Session active: ${session.id}');
    _reliabilityService.startHeartbeat();
  }

  Future<void> sendTestMessage() async {
    final packet = await _messageService.sendEncryptedMessage('BlueTalk secure ping');
    _logs.insert(0, 'Sent packet: ${packet.messageId}');
  }

  Future<void> simulateReconnect() async {
    await _reliabilityService.handleTimeoutAndReconnect();
    _logs.insert(0, 'Reconnect attempted');
  }

  Future<void> teardown() async {
    await _reliabilityService.gracefulTeardown();
    _sessionOrchestrator.resetSessionOnDisconnect();
    await _messageSub?.cancel();
    await _ackSub?.cancel();
    _logs.insert(0, 'Session torn down');
  }
}
