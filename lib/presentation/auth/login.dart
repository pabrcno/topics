import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            SignInButton(
              onPressed: () => authServiceProvider.signInWithGoogle(),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  const SignInButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await widget.onPressed();
              } catch (e) {
                // Handle the exception here
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Sign in with Google'),
    );
  }
}
