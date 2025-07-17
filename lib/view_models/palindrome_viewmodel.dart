import 'package:flutter/material.dart';
import '../models/palindrome_model.dart';

class PalindromeViewModel extends ChangeNotifier {
  PalindromeModel _model = PalindromeModel(name: '', sentence: '');

  void updateName(String name) {
    _model = PalindromeModel(name: name, sentence: _model.sentence);
    notifyListeners();
  }

  void updateSentence(String sentence) {
    _model = PalindromeModel(name: _model.name, sentence: sentence);
    notifyListeners();
  }

  String get name => _model.name;
  String get sentence => _model.sentence;

  bool isPalindrome() {
    String cleaned = _model.sentence.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return cleaned == cleaned.split('').reversed.join('');
  }
}
