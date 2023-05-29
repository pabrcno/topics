import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../services/auth_service.dart';
import '../legal/privacy_policy.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  Future<String> getVersionNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/logo_with_label_1-removebg-preview.png',
              width: 300,
            ),
            SignInButton(
              onPressed: () => authServiceProvider.signInWithGoogle(),
            ),
            FutureBuilder<String>(
              future: getVersionNumber(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return Text('Version: ${snapshot.data}');
                }
              },
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicyScreen(),
                ),
              ),
              child: const Text('Privacy Policy'),
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
