import 'package:flutter/material.dart';

class BaseException implements Exception {
  final String? message;

  BaseException({this.message});

  @override
  String toString() {
    return message ?? 'An exception occurred';
  }
}

class ExceptionNotifier with ChangeNotifier {
  Object? _lastException;

  Object? get lastException => _lastException;

  void addException(Object exception) {
    //check if exception contains message attribute
    if (exception is BaseException) {
      _lastException = exception.message;
    } else {
      _lastException = exception.toString();
    }

    notifyListeners();
  }
}
