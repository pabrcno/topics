import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ChatInfo extends StatelessWidget {
  const ChatInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('chat_info_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSection(
              icon: Icons.camera_alt,
              title: translate('ocr_tool_title'),
              description: [
                translate('scan_text_description'),
                translate('capture_image_description'),
                translate('crop_image_description'),
                translate('recognize_text_description'),
              ],
            ),
            const SizedBox(height: 24.0),
            _buildSection(
              icon: Icons.lightbulb_outline,
              title: translate('suggested_prompts_title'),
              description: [
                translate('select_prompt_description'),
                translate('use_prompt_description'),
              ],
            ),
            const SizedBox(height: 24.0),
            _buildSection(
              icon: Icons.thermostat_outlined,
              title: translate('temperature_slider_title'),
              description: [
                translate('adjust_temperature_description'),
                translate('drag_slider_description'),
                translate('higher_temperature_description'),
              ],
            ),
            const SizedBox(height: 24.0),
            _buildSection(
              icon: Icons.camera,
              title: translate('permissions_info'),
              description: [
                translate('camera_permission_note'),
              ],
              fontStyle: FontStyle.italic,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<String> description,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: description
              .map(
                (desc) => Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: fontStyle,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
