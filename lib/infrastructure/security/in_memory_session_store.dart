import '../../domain/entities/session.dart';
import '../../domain/repositories/session_store.dart';

class InMemorySessionStore implements SessionStore {
  Session? _current;
  final Set<String> _usedNonces = <String>{};
  bool _isConnected = false;

  @override
  Session? get current => _current;

  @override
  Set<String> get usedNonces => _usedNonces;

  @override
  bool get isConnected => _isConnected;

  @override
  void activate(Session session) {
    _current = session;
    _usedNonces.clear();
  }

  @override
  void clear() {
    _current = null;
    _usedNonces.clear();
    _isConnected = false;
  }

  @override
  void markConnected(bool connected) {
    _isConnected = connected;
  }

  @override
  bool registerNonce(String nonce) {
    return _usedNonces.add(nonce);
  }
}
