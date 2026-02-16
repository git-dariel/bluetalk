import '../entities/session.dart';

abstract class SessionStore {
  Session? get current;
  Set<String> get usedNonces;
  bool get isConnected;

  void markConnected(bool connected);
  void activate(Session session);
  void clear();
  bool registerNonce(String nonce);
}
