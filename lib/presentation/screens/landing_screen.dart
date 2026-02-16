import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../design/tokens.dart';
import '../widgets/glass_action_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/landing_page.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.transparent,
                  BlueTalkColors.landingOverlay
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
              child: Column(
                children: <Widget>[
                  Text(
                    'bluetalk.',
                    style: GoogleFonts.imFellEnglish(
                      fontSize: 80,
                      fontStyle: FontStyle.italic,
                      color: BlueTalkColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Chat nearby. No internet needed.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF27443E)),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: GlassActionButton(
                      label: 'Start',
                      onTap: onStart,
                      height: 62,
                      radius: 32,
                      tint: const Color(0x044F4A3F),
                      highlight: const Color(0x20FFFFFF),
                      blurSigma: 32,
                      topGlassOpacity: 0.0,
                      shadowOpacity: 0.0,
                      textStyle: GoogleFonts.imFellEnglish(
                        fontSize: 38,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
