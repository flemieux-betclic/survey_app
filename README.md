

# Flutter Quiz App

A small Flutter quiz app built as a learning project. Answer a set of
Flutter questions and get instant, playful feedback along the way — then
see your score on a congratulations screen.

## Demo

https://github.com/user-attachments/assets/f6ced203-85af-486b-a7c3-21501426ac4b

## Features

- **Welcome screen** — logo, tagline, and a ghost "Start Quiz" button.
- **Question flow** — one question at a time with shuffled answers.
- **Instant answer feedback:**
  - ✅ Correct → green background flash, a check icon, and a confetti burst.
  - ❌ Wrong → black background flash and a falling "rain" effect.
- **Results screen** — final score with a congratulations message.
- **Navigation** — back to the welcome screen at any time; "Finish" returns
  home after the last question.
- **Responsive layout** — screens stay centered and adapt (scroll instead of
  overflow) in both portrait and landscape.

## Tech stack

- [Flutter](https://flutter.dev/) (Dart)
- [`confetti`](https://pub.dev/packages/confetti) — celebration & rain effects

## Getting started

```bash
# Install dependencies
flutter pub get

# Run on a connected device or simulator
flutter run
```

## Project structure

```
lib/
├── main.dart              # App entry; drives welcome → questions → results
├── welcome_screen.dart    # Landing screen with the Start Quiz button
├── questions_screen.dart  # Question flow + answer feedback effects
├── results_screen.dart    # Score and congratulations
├── questions.dart         # Quiz question data
└── quiz_question.dart      # QuizQuestion model
```

---

Built while learning Flutter. 🐦
