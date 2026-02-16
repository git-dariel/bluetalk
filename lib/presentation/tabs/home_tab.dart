import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../models/chat_models.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.users,
    required this.scanEnabled,
    this.statusMessage,
    required this.onScanChanged,
    required this.onConnectUser,
  });

  final List<NearbyUser> users;
  final bool scanEnabled;
  final String? statusMessage;
  final ValueChanged<bool> onScanChanged;
  final ValueChanged<NearbyUser> onConnectUser;

  @override
  Widget build(BuildContext context) {
    final bool empty = !scanEnabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Nearby Users',
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Switch(
              value: scanEnabled,
              onChanged: onScanChanged,
              activeColor: BlueTalkColors.primaryText,
              inactiveThumbColor: const Color(0xFF8A8F80),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: empty
              ? const Center(
                  child: Text(
                    'No users found.',
                    style: TextStyle(color: Color(0xFF5A6C5E), fontSize: 18),
                  ),
                )
              : ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (BuildContext context, int index) {
                    final NearbyUser user = users[index];
                    return GestureDetector(
                      onTap:
                          user.isConnected ? null : () => onConnectUser(user),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(BlueTalkRadius.medium),
                          color: const Color(0x40FFFFFF),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: user.isConnected
                                  ? Colors.green.withOpacity(0.25)
                                  : Colors.grey.withOpacity(0.25),
                              child: Text(
                                user.name.substring(0, 1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color(0xFF163A33),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.isConnected
                                        ? 'Connected'
                                        : 'Tap to connect',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: user.isConnected
                                          ? Colors.green
                                          : const Color(0xFF5A6C5E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              user.isConnected ? Icons.link : Icons.bluetooth,
                              color: user.isConnected
                                  ? Colors.green
                                  : const Color(0xFF5A6C5E),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: BlueTalkSpacing.s8),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (scanEnabled)
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF5A6C5E),
                  ),
                ),
              if (scanEnabled) const SizedBox(height: 8),
              Text(
                scanEnabled ? 'Scanning...' : 'Scan is Off',
                style: const TextStyle(color: Color(0xFF5A6C5E), fontSize: 16),
              ),
              if (statusMessage != null) const SizedBox(height: 6),
              if (statusMessage != null)
                Text(
                  statusMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF8A5348),
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
