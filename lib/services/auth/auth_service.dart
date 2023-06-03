import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:topics/services/auth/user_credential_dto.dart';

import '../../../domain/models/auth/app_user_credential.dart';
import '../../../domain/models/user/app_user.dart';
import '../../../domain/repo/i_user_repository.dart';
import '../../../domain/services/i_auth_service.dart';
import '../../../services/exception_handling_service.dart';
import '../../presentation/auth/login.dart';
import '../../presentation/home/home.dart';
import '../../repo/user/firestore_user_repo.dart';

class AuthService implements IAuthService {
  final IUserRepository userRepository = FirestoreUserRepository();
  final ErrorCommander errorCommander = ErrorCommander();

  AuthService();

  @override
  Future<AppUserCredential?> signInWithGoogle() async {
    return errorCommander.run(() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ["email"]).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user == null) {
        return null;
      }
      // Check if the user is already registered in Firestore
      AppUser? user = await userRepository.getUser(userCredential.user!.uid);

      // If the user doesn't exist in Firestore, create a new document for the user
      if (user == null) {
        user = AppUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName ?? '',
          photoURL: userCredential.user!.photoURL ?? '',
          emailVerified: userCredential.user!.emailVerified,
          subscription: ESubscriptions.basic, // default subscription
          messageCount: 0, // default message count
          createdAt: DateTime.now(),
        );

        await userRepository.createUser(user);
      }

      return UserCredentialDTO.fromFirebaseUser(userCredential.user!)
          .toDomain();
    });
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  AppUserCredential? getCurrentUser() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;
    return UserCredentialDTO.fromFirebaseUser(firebaseUser).toDomain();
  }

  @override
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges().map((event) {
        if (event == null) return null;
        return UserCredentialDTO.fromFirebaseUser(event).toDomain();
      }),
      builder:
          (BuildContext context, AsyncSnapshot<AppUserCredential?> snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  @override
  Future<String?> getUserToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }
}
