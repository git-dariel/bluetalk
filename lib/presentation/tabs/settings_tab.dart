import 'package:flutter/material.dart';

import '../design/tokens.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.username,
    required this.onEditUsername,
    required this.onClearHistory,
    required this.onOpenAbout,
    required this.onOpenGallery,
  });

  final String username;
  final VoidCallback onEditUsername;
  final VoidCallback onClearHistory;
  final VoidCallback onOpenAbout;
  final VoidCallback onOpenGallery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Settings', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BlueTalkColors.borderWarm),
          ),
          child: Column(
            children: <Widget>[
              const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFF5E6665),
                child: Icon(Icons.camera_alt_outlined, color: Colors.white),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: onEditUsername,
                child: Text(
                  '$username ✎',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: BlueTalkColors.primaryText,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _SettingsButton(
          icon: Icons.photo_library_outlined,
          label: 'Gallery',
          onTap: onOpenGallery,
        ),
        const SizedBox(height: 8),
        _SettingsButton(
          icon: Icons.delete_outline,
          label: 'Clear Chat History',
          onTap: onClearHistory,
        ),
        const SizedBox(height: 8),
        _SettingsButton(
          icon: Icons.info_outline,
          label: 'About',
          onTap: onOpenAbout,
        ),
      ],
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BlueTalkColors.borderWarm),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: BlueTalkColors.primaryText),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 20, color: BlueTalkColors.primaryText),
            ),
          ],
        ),
      ),
    );
  }
}
