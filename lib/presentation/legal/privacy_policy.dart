import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({Key? key}) : super(key: key);

  final List<String> privacyPolicySections = [
    'Privacy Policy for Topics',
    '\n\nLast updated: 5/28/2023',
    '\n\nThis Privacy Policy describes how Paulo Briceno ("we", "us", or "our") collects, uses, and shares information in connection with your use of our mobile application Topics (the "App").',
    '\n\nInformation We Collect',
    '\n\nCamera: Our app requires access to your device\'s camera to enable Optical Character Recognition (OCR) functionalities and to handle images provided by the user. We use the images captured by the camera to provide these features and improve your user experience.',
    '\n\nStorage: Our app requires access to your device\'s storage to store internal state related to multiple versions. This helps us maintain your preferences and provide a consistent user experience.',
    '\n\nUser Data: We store user data in Firebase, adhering to strict authentication policies to ensure the security and privacy of your data. This data is used to personalize your experience and provide you with relevant features and services.',
    '\n\nHow We Use Your Information',
    '\n\nWe use the information we collect to provide, maintain, and improve the App. This includes using the data to personalize your experience, provide customer support, and develop new features.',
    '\n\nHow We Share Your Information',
    '\n\nWe do not share your information with third parties, except as required by law or to protect our rights and interests.',
    '\n\nYour Choices',
    '\n\nYou can control the App\'s access to your device\'s camera and storage through your device\'s settings. However, please note that if you do not allow the App to access these features, some features of the App may not work properly.',
    '\n\nLimitation of Liability',
    '\n\nWhile we strive to protect your information to the best of our ability, we cannot guarantee its absolute security. Any data you transmit to the App is at your own risk. We are not responsible for any damages or harms resulting from your use of the App or the sharing of your data with us.',
    '\n\nChanges to This Privacy Policy',
    '\n\nWe may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
    '\n\nContact Us',
    '\n\nIf you have any questions about this Privacy Policy, please contact us at topics.contact+privacy@gmail.com .',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: privacyPolicySections.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(
            privacyPolicySections[index],
            style: DefaultTextStyle.of(context).style,
          );
        },
      ),
    );
  }
}
