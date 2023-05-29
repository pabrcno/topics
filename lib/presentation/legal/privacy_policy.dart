import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: const <TextSpan>[
              TextSpan(text: 'Privacy Policy for Topics\n\n'),
              TextSpan(text: 'Last updated: 5/28/2023\n\n'),
              TextSpan(
                  text:
                      'This Privacy Policy describes how Paulo Briceno ("we", "us", or "our") collects, uses, and shares information in connection with your use of our mobile application Topics (the "App").\n\n'),
              TextSpan(text: 'Information We Collect\n\n'),
              TextSpan(
                  text:
                      'Camera: Our app requires access to your device\'s camera to enable Optical Character Recognition (OCR) functionalities and to handle images provided by the user. We use the images captured by the camera to provide these features and improve your user experience.\n\n'),
              TextSpan(
                  text:
                      'Storage: Our app requires access to your device\'s storage to store internal state related to multiple versions. This helps us maintain your preferences and provide a consistent user experience.\n\n'),
              TextSpan(
                  text:
                      'User Data: We store user data in Firebase, adhering to strict authentication policies to ensure the security and privacy of your data. This data is used to personalize your experience and provide you with relevant features and services.\n\n'),
              TextSpan(text: 'How We Use Your Information\n\n'),
              TextSpan(
                  text:
                      'We use the information we collect to provide, maintain, and improve the App. This includes using the data to personalize your experience, provide customer support, and develop new features.\n\n'),
              TextSpan(text: 'How We Share Your Information\n\n'),
              TextSpan(
                  text:
                      'We do not share your information with third parties, except as required by law or to protect our rights and interests.\n\n'),
              TextSpan(text: 'Your Choices\n\n'),
              TextSpan(
                  text:
                      'You can control the App\'s access to your device\'s camera and storage through your device\'s settings. However, please note that if you do not allow the App to access these features, some features of the App may not work properly.\n\n'),
              TextSpan(text: 'Limitation of Liability\n\n'),
              TextSpan(
                  text:
                      'While we strive to protect your information to the best of our ability, we cannot guarantee its absolute security. Any data you transmit to the App is at your own risk. We are not responsible for any damages or harms resulting from your use of the App or the sharing of your data with us.\n\n'),
              TextSpan(text: 'Changes to This Privacy Policy\n\n'),
              TextSpan(
                  text:
                      'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n'),
              TextSpan(text: 'Contact Us\n\n'),
              TextSpan(
                  text:
                      'If you have any questions about this Privacy Policy, please contact us at topics.contact+privacy@gmail.com .'),
            ],
          ),
        ),
      ),
    );
  }
}
