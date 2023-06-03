import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class ErrorCommander {
  static Future<void> Function(String)? _showSnackbar;

  ErrorCommander();

  static set showSnackbar(Future<void> Function(String)? func) {
    _showSnackbar = func;
  }

  void _logger(dynamic error) {
    log('Error occurred: ${error.toString()}');
  }

  void _handleError(dynamic error) {
    // Log the error
    _logger(error);

    String message;
    if (error is FormatException) {
      message = 'error_invalid_format';

      // Firebase Exceptions
    } else if (error is FirebaseException) {
      message = 'error_firebase';

      // FirebaseAuth Exceptions
    } else if (error is FirebaseAuthException) {
      message = 'error_authentication';

      // Cloud Firestore Exceptions
    } else if (error is FirebaseException) {
      message = 'error_firestore';
      // Socket Exceptions
    } else if (error is SocketException) {
      message = 'error_no_internet';

      // General case
    } else {
      message = '$error';
    }

    if (_showSnackbar != null) {
      // Display the snackbar
      _showSnackbar!(message);
    }
  }

  Future<T> run<T>(Future<T> Function() execute,
      {void Function(dynamic)? onError}) async {
    try {
      return await execute();
    } catch (error) {
      if (onError != null) {
        onError(error);
      } else {
        _handleError(error);
      }
      rethrow; // If you want the error to propagate further.
    }
  }
}
