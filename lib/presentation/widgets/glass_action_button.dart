import 'dart:ui';

import 'package:flutter/material.dart';

class GlassActionButton extends StatelessWidget {
  const GlassActionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.textStyle,
    this.height = 62,
    this.radius = 32,
    this.tint = const Color(0x66223F39),
    this.highlight = const Color(0x55FFFFFF),
    this.blurSigma = 22,
    this.topGlassOpacity = 0.26,
    this.shadowOpacity = 0.12,
  });

  final String label;
  final VoidCallback onTap;
  final TextStyle textStyle;
  final double height;
  final double radius;
  final Color tint;
  final Color highlight;
  final double blurSigma;
  final double topGlassOpacity;
  final double shadowOpacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: highlight, width: 1.2),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.white.withOpacity(topGlassOpacity),
                    tint,
                  ],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(shadowOpacity),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(label, style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
