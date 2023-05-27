import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class ErrorCommander {
  final Future<void> Function(String) _showSnackbar;

  ErrorCommander(Future<void> Function(String) showSnackbar)
      : _showSnackbar = showSnackbar;
  void _logger(dynamic error) {
    log('Error occurred: ${error.toString()}');
  }

  void _handleError(dynamic error) {
    // Log the error
    _logger(error);

    String message;

    if (error is FormatException) {
      message = 'Invalid format. Please check your input.';

      // Firebase Exceptions
    } else if (error is FirebaseException) {
      message = 'Firebase error: ${error.message}';

      // FirebaseAuth Exceptions
    } else if (error is FirebaseAuthException) {
      message = 'Authentication error: ${error.message}';

      // Cloud Firestore Exceptions
    } else if (error is FirebaseException) {
      message = 'Firestore error: ${error.message}';
      // Socket Exceptions
    } else if (error is SocketException) {
      message =
          'No internet connection. Please check your connection and try again.';

      // General case
    } else {
      message = 'An unexpected issue occurred. Please try again.';
    }

    // Display the snackbar
    _showSnackbar(message);
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
