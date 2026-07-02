import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import 'questions.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
    required this.onBack,
  });

  /// Called with the answer chosen for the current question.
  final void Function(String answer) onSelectAnswer;

  /// Called when the user wants to leave the quiz (back to welcome).
  final void Function() onBack;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  // A hue sitting between pink and purple, matching the welcome screen.
  static const Color _pinkPurple = Color(0xFFD8B4FE);

  // Fixed height reserved for the question text, so the answer buttons keep
  // a stable vertical position regardless of how long the question is.
  static const double _questionSlotHeight = 120;

  int _currentQuestionIndex = 0;
  bool _isProcessingAnswer = false;
  // null = idle, true = last answer correct, false = last answer wrong.
  bool? _answerCorrect;
  late final ConfettiController _confettiController;
  late final ConfettiController _rainController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 900),
    );
    _rainController = ConfettiController(
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _rainController.dispose();
    super.dispose();
  }

  Future<void> _answerQuestion(String selectedAnswer) async {
    if (_isProcessingAnswer) {
      return;
    }

    final currentQuestion = questions[_currentQuestionIndex];
    final isCorrect = selectedAnswer == currentQuestion.answers.first;

    setState(() {
      _isProcessingAnswer = true;
      _answerCorrect = isCorrect;
    });

    if (isCorrect) {
      _confettiController.play();
    } else {
      _rainController.play();
    }
    await Future<void>.delayed(const Duration(milliseconds: 950));

    if (!mounted) {
      return;
    }

    final isLastQuestion = _currentQuestionIndex >= questions.length - 1;

    // Report the answer to the parent. On the last question this triggers the
    // switch to the results screen, so we don't advance our own index.
    widget.onSelectAnswer(selectedAnswer);

    if (isLastQuestion) {
      return;
    }

    setState(() {
      _currentQuestionIndex++;
      _isProcessingAnswer = false;
      _answerCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[_currentQuestionIndex];

    // Feedback background: green when correct, black when wrong, otherwise
    // transparent so the parent's purple shows through.
    final Color feedbackColor = switch (_answerCorrect) {
      true => const Color(0xFF2E7D32),
      false => Colors.black,
      null => Colors.transparent,
    };

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            color: feedbackColor,
          ),
        ),
        SafeArea(
          // Scroll + center: content is centered when it fits, and becomes
          // scrollable (no overflow) when the screen is short, e.g. landscape.
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Fixed-height slot keeps the buttons below from
                          // shifting when the question text wraps.
                          SizedBox(
                            height: _questionSlotHeight,
                            child: Center(
                              child: Text(
                                currentQuestion.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ...currentQuestion.shuffledAnswers().map(
                            (answer) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ElevatedButton(
                                onPressed: _isProcessingAnswer
                                    ? null
                                    : () => _answerQuestion(answer),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8E24AA),
                                  foregroundColor: _pinkPurple,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  answer,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Back button to return to the welcome screen.
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: _isProcessingAnswer ? null : widget.onBack,
              icon: const Icon(Icons.arrow_back),
              color: _pinkPurple,
              tooltip: 'Back',
            ),
          ),
        ),
        // Celebration burst for a correct answer.
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.06,
            numberOfParticles: 24,
            maxBlastForce: 35,
            minBlastForce: 12,
            gravity: 0.28,
            shouldLoop: false,
          ),
        ),
        // Rain effect for a wrong answer: particles fall straight down.
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _rainController,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: pi / 2, // downward
            emissionFrequency: 0.35,
            numberOfParticles: 6,
            maxBlastForce: 6,
            minBlastForce: 2,
            gravity: 0.6,
            shouldLoop: false,
            colors: const [
              Color(0xFF64B5F6),
              Color(0xFF2196F3),
              Color(0xFF90CAF9),
              Color(0xFFB3E5FC),
            ],
          ),
        ),
        // Check symbol shown when the answer is correct.
        Center(
          child: AnimatedScale(
            scale: _answerCorrect == true ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 140,
            ),
          ),
        ),
      ],
    );
  }
}
