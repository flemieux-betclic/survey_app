import 'package:flutter/material.dart';

/// The first screen shown when the app launches.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.startQuiz});

  final void Function() startQuiz;

  // A hue sitting between pink and purple, used for the tagline text.
  static const Color _pinkPurple = Color(0xFFD8B4FE);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: availableHeight),
              child: IntrinsicHeight(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      // Push the image down to the 12% mark of the height.
                      SizedBox(height: availableHeight * 0.12),
                      // Image occupies the vertical band from 12% to ~47%.
                      SizedBox(
                        height: availableHeight * 0.35,
                        child: Center(
                          child: Image.asset('assets/images/quiz-logo.png'),
                        ),
                      ),
                      const SizedBox(height: 56),
                      const Text(
                        'Learn Flutter the fun way!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _pinkPurple,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Ghost button: transparent fill with a subtle border.
                      OutlinedButton(
                        onPressed: startQuiz,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _pinkPurple,
                          side: const BorderSide(
                            color: _pinkPurple,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Start Quiz',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      // Bottom breathing room when scrolled in short layouts.
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
