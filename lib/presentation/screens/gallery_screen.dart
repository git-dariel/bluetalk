import 'package:flutter/material.dart';

import '../design/tokens.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Color> colors = <Color>[
      Color(0xFF4F5C54),
      Color(0xFF8B6F50),
      Color(0xFFA58C88),
      Color(0xFF3E4E5E),
      Color(0xFF66716A),
      Color(0xFF59718A),
      Color(0xFF836D4A),
      Color(0xFF6E5D7E),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('bluetalk.')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.86,
          ),
          itemCount: colors.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == colors.length) {
              return Container(
                decoration: BoxDecoration(
                  color: BlueTalkColors.navPill,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add,
                    size: 40, color: BlueTalkColors.primaryText),
              );
            }
            return Container(
              decoration: BoxDecoration(
                color: colors[index],
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.more_horiz, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
