/// A single quiz question with its possible answers.
///
/// By convention the first entry in [answers] is the correct one.
class QuizQuestion {
  const QuizQuestion(this.text, this.answers);

  final String text;
  final List<String> answers;

  /// Answers in a shuffled order, so the correct one isn't always first.
  List<String> shuffledAnswers() {
    final shuffled = List.of(answers);
    shuffled.shuffle();
    return shuffled;
  }
}
