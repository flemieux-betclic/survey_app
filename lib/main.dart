import 'package:flutter/material.dart';

import 'questions.dart';
import 'questions_screen.dart';
import 'results_screen.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      home: Quiz(),
    );
  }
}

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

enum _Screen { welcome, questions, results }

class _QuizState extends State<Quiz> {
  _Screen _activeScreen = _Screen.welcome;
  List<String> _selectedAnswers = [];

  void _startQuiz() {
    setState(() {
      _selectedAnswers = [];
      _activeScreen = _Screen.questions;
    });
  }

  void _chooseAnswer(String answer) {
    _selectedAnswers.add(answer);
    if (_selectedAnswers.length == questions.length) {
      setState(() {
        _activeScreen = _Screen.results;
      });
    }
  }

  void _backToWelcome() {
    setState(() {
      _selectedAnswers = [];
      _activeScreen = _Screen.welcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget activeScreen = switch (_activeScreen) {
      _Screen.welcome => WelcomeScreen(startQuiz: _startQuiz),
      _Screen.questions => QuestionsScreen(
        onSelectAnswer: _chooseAnswer,
        onBack: _backToWelcome,
      ),
      _Screen.results => ResultsScreen(
        chosenAnswers: _selectedAnswers,
        onFinish: _backToWelcome,
      ),
    };

    return Scaffold(
      backgroundColor: const Color(0xFF6A1B9A),
      body: activeScreen,
    );
  }
}
