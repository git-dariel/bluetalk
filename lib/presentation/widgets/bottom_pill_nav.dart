import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../design/tokens.dart';

class BottomPillNav extends StatelessWidget {
  const BottomPillNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const List<IconData> icons = <IconData>[
      Ionicons.home,
      Ionicons.chatbubble_outline,
      Ionicons.settings_outline,
    ];

    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: BlueTalkColors.navPill,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<Widget>.generate(icons.length, (int index) {
          final bool selected = index == currentIndex;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: selected ? 20 : 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? BlueTalkColors.primaryText.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedScale(
                    scale: selected ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      icons[index],
                      size: 26,
                      color: selected
                          ? BlueTalkColors.primaryText
                          : const Color(0xFF304B45),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: selected ? 6 : 0,
                    height: selected ? 6 : 0,
                    decoration: const BoxDecoration(
                      color: BlueTalkColors.primaryText,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
