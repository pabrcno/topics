import 'package:flutter/material.dart';
import 'package:topics/domain/models/auth/app_user_credential.dart';

abstract class IAuthService {
  Future<AppUserCredential?> signInWithGoogle();
  Future<void> signOut();
  AppUserCredential? getCurrentUser();
  StreamBuilder<AppUserCredential?> handleAuthState();
}
