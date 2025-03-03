import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

sealed class GameplayState {}

final class Initial extends GameplayState {}

final class InProgress extends GameplayState {}

final class Overlayed extends GameplayState {
  final Color color;

  Overlayed(this.color);
}

final class Paused extends GameplayState {}

final class Completed extends GameplayState {}

class WordResult {
  final String word;
  final bool isGuessed;

  WordResult(this.word, this.isGuessed);
}

class GameplayModel extends ChangeNotifier {
  static const int _initialTime = 60;
  final List<String> _words = [
    'Dog',
    'Cat',
    'Elephant',
    'Lion',
    'Tiger',
    'Bear',
    'Wolf',
  ];
  GameplayState gameplayState = Initial();

  Timer? _timer;
  int _timeLeft = _initialTime;
  String _currentWord = "";

  final List<WordResult> guessedWords = [];

  int get timeLeft => _timeLeft;

  String get currentWord => _currentWord;

  bool get isTimeOver => _timeLeft <= 0;

  // Start/resume the game
  void startGame() {
    // If there is an active timer, cancel it to avoid duplication
    _timer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    // Reset time if needed
    _timeLeft = _initialTime;
    guessedWords.clear();
    _currentWord = _getRandomWord()!;
    gameplayState = InProgress();
    notifyListeners();

    // Start countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
      } else {
        gameplayState = Completed();
        timer.cancel();
      }
      notifyListeners();
    });
  }

  // Choose next word (helper method)
  String? _getRandomWord() {
    if (_words.isEmpty) return null;
    _words.shuffle();
    return _words.removeAt(0);
  }

  // When user presses skip
  void skipWord() {
    if (!isTimeOver) {
      guessedWords.add(WordResult(_currentWord, false));
      showOverlay(Colors.green);
    }
  }

  // When user presses guessed
  void guessedWord() {
    if (!isTimeOver) {
      guessedWords.add(WordResult(_currentWord, true));
      showOverlay(Colors.green);
    }
  }

  void showOverlay(Color color) {
    gameplayState = Overlayed(color);
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      gameplayState = InProgress();
      final word = _getRandomWord();
      if (word != null) {
        _currentWord = word;
      } else {
        _timer?.cancel();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        gameplayState = Completed();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
