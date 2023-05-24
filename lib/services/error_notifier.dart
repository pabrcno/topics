import 'package:flutter/material.dart';

class ErrorNotifier with ChangeNotifier {
  Object? _lastError;

  Object? get lastError => _lastError;

  void addError(Object error) {
    _lastError = error;
    notifyListeners();
  }
}
