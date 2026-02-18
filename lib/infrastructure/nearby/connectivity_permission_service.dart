import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class ConnectivityPermissionService {
  Future<bool> requestConnectivityPermissions() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return true;
    }

    if (Platform.isIOS) {
      final PermissionStatus status = await Permission.bluetooth.request();
      return status.isGranted || status.isLimited;
    }

    final Map<Permission, PermissionStatus> statuses = await <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();

    final bool canScan = statuses[Permission.bluetoothScan]?.isGranted ?? false;
    final bool canConnect =
        statuses[Permission.bluetoothConnect]?.isGranted ?? false;

    await Permission.locationWhenInUse.request();
    await Permission.location.request();
    await Permission.nearbyWifiDevices.request();

    return canScan && canConnect;
  }
}
