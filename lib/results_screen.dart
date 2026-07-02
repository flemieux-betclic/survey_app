import 'package:flutter/material.dart';

import 'questions.dart';

/// Final screen showing the score and a congratulations message.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onFinish,
  });

  /// The answers the user picked, in question order.
  final List<String> chosenAnswers;

  /// Called when the user taps "Finish" (returns to the welcome screen).
  final void Function() onFinish;

  // A hue sitting between pink and purple, matching the other screens.
  static const Color _pinkPurple = Color(0xFFD8B4FE);

  int get _correctCount {
    var count = 0;
    for (var i = 0; i < chosenAnswers.length && i < questions.length; i++) {
      if (chosenAnswers[i] == questions[i].answers.first) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final total = questions.length;
    final correct = _correctCount;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 24,
                  ),
                  // Force full width so the centered children sit in the
                  // middle of the screen instead of shrink-wrapping left.
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: _pinkPurple,
                          size: 96,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Congratulations!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You answered $correct out of $total questions correctly!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _pinkPurple,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Ghost button, matching the welcome screen's style.
                        OutlinedButton(
                          onPressed: onFinish,
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
                            'Finish',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
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
