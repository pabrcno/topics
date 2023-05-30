import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({Key? key}) : super(key: key);
  final List<String> privacyPolicySections = [
    'privacy_policy_title',
    'last_updated_date',
    'privacy_policy_description',
    'information_we_collect',
    'camera_info',
    'storage_info',
    'user_data_info',
    'how_we_use_info',
    'how_we_use_info_description',
    'how_we_share_info',
    'how_we_share_info_description',
    'your_choices',
    'your_choices_description',
    'limitation_of_liability',
    'limitation_of_liability_description',
    'changes_to_privacy_policy',
    'changes_to_privacy_policy_description',
    'contact_us',
    'contact_us_description',
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
            translate(privacyPolicySections[index]),
            style: DefaultTextStyle.of(context).style,
          );
        },
      ),
    );
  }
}
