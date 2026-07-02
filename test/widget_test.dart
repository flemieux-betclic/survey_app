import 'package:flutter_test/flutter_test.dart';

import 'package:survey_app/main.dart';

void main() {
  testWidgets('Shows welcome screen text', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.text('Learn Flutter the fun way!'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);
  });
}
