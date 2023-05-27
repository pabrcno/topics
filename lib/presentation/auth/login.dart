import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      loading = true;
    });
    await authServiceProvider.signInWithGoogle().then((_) {
      setState(() {
        loading = false;
      });
    }).catchError((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_with_label_1-removebg-preview.png',
              width: 300,
            ),
            loading
                ? const CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: signInWithGoogle,
                    child: const Text('Sign in with Google'),
                  ),
          ],
        ),
      ),
    );
  }
}
