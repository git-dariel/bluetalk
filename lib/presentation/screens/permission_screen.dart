import 'dart:ui';

import 'package:flutter/material.dart';

import '../design/tokens.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key, required this.onContinue});

  final Future<void> Function() onContinue;

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
                  BlueTalkColors.landingOverlay,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
              child: Column(
                children: <Widget>[
                  const Text(
                    'bluetalk.',
                    style: TextStyle(
                      fontFamily: 'IMFellEnglish',
                      fontSize: 80,
                      fontStyle: FontStyle.italic,
                      color: BlueTalkColors.primaryText,
                    ),
                  ),
                  const Text(
                    'Chat nearby. No internet needed.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF27443E)),
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(BlueTalkRadius.large),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.white.withOpacity(0.04),
                              const Color(0x081E2B2A),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(BlueTalkRadius.large),
                          border: Border.all(color: const Color(0x20FFFFFF)),
                        ),
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'Bluetalk lets you find nearby people and send messages — even without internet.\n'
                              'We only use it for chatting with people close to you and emergency purposes.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.5,
                                color: Color(0xFFE5E3D8),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 54),
                                  backgroundColor: BlueTalkColors.navPill,
                                  foregroundColor: const Color(0xFF153A33),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                ),
                                onPressed: () => onContinue(),
                                child: const Text(
                                  'Allow & Continue',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
