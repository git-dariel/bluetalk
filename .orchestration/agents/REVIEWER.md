# REVIEWER Agent – BlueTalk (Flutter)

## Review Checklist

- Is Clean Architecture preserved?
- Is domain layer Flutter-independent?
- Is encryption enforced before send?
- Are BLE streams disposed properly?
- Are timeouts handled?
- Is state management clean?

Reject if:

- Business logic in widgets
- BLE adapter accessed directly from UI
- Encryption bypassed
- Hardcoded device identifiers
