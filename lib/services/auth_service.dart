import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:topics/presentation/home/home.dart';

import '../presentation/auth/login.dart';
import '../repo/user/firestore_user_repo.dart';

class AuthService {
  final FirestoreUserRepository userRepository = FirestoreUserRepository();

  AuthService();
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  signInWithGoogle() async {
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

    // Check if the user is already registered in Firestore
    final DocumentSnapshot userDoc =
        await userRepository.getUser(userCredential.user!.uid);

    // If the user doesn't exist in Firestore, create a new document for the user
    if (!userDoc.exists) {
      await userRepository.createUser(userCredential.user!.uid, {
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'photoURL': userCredential.user!.photoURL,
        'phoneNumber': userCredential.user!.phoneNumber,
        'id': userCredential.user!.uid,
        'role': 'user',
      });
    }
    return userCredential;
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}

final authServiceProvider = AuthService();
