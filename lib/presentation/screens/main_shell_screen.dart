import 'package:flutter/material.dart';

import '../controllers/shell_controller.dart';
import '../models/chat_models.dart';
import '../tabs/home_tab.dart';
import '../tabs/messages_tab.dart';
import '../tabs/settings_tab.dart';
import '../widgets/bottom_pill_nav.dart';
import 'about_screen.dart';
import 'chat_detail_screen.dart';
import 'gallery_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({
    super.key,
    required this.controller,
  });

  final ShellController controller;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  ShellController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.onPeerConnected = _onPeerConnected;
  }

  @override
  void dispose() {
    controller.onPeerConnected = null;
    super.dispose();
  }

  void _onPeerConnected(String peerName) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connected to $peerName — say hi! 👋'),
        backgroundColor: const Color(0xFF2C3E2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Go to Messages',
          textColor: const Color(0xFFADC9A3),
          onPressed: () => controller.setTab(1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        final List<Widget> tabs = <Widget>[
          HomeTab(
            users: controller.nearbyUsers,
            scanEnabled: controller.scanEnabled,
            statusMessage: controller.statusMessage,
            onScanChanged: controller.setScanEnabled,
            onConnectUser: controller.connectToUser,
          ),
          MessagesTab(
            threads: controller.threads,
            onOpenThread: (ChatThread thread) {
              controller.setActiveThread(thread.name);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, __) => ChatDetailScreen(
                      title: thread.name,
                      messages: controller.messagesForThread(thread.name),
                      onSendMessage: (String text) =>
                          controller.sendMessageToThread(thread.name, text),
                    ),
                  ),
                ),
              );
            },
          ),
          SettingsTab(
            username: controller.username,
            onEditUsername: () => _showEditUsername(context),
            onClearHistory: () => _showClearHistoryConfirm(context),
            onOpenAbout: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
              );
            },
            onOpenGallery: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const GalleryScreen()),
              );
            },
          ),
        ];

        return Scaffold(
          appBar: AppBar(title: const Text('bluetalk.')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                children: <Widget>[
                  Expanded(child: tabs[controller.tabIndex]),
                  const SizedBox(height: 12),
                  BottomPillNav(
                    currentIndex: controller.tabIndex,
                    onChanged: controller.setTab,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditUsername(BuildContext context) async {
    final TextEditingController textController =
        TextEditingController(text: controller.username);

    final String? value = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE6EAD8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Username'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, textController.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (value != null) {
      controller.updateUsername(value);
    }
  }

  Future<void> _showClearHistoryConfirm(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE6EAD8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Clear Chat History'),
          content: const Text(
              'This action cannot be undone. Do you want to continue?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      controller.clearChatHistory();
    }
  }
}
