import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/constants.dart';

class ImageEqualizerButton extends StatelessWidget {
  const ImageEqualizerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.equalizer),
      label: Text(translate('imageEqualizer')),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => const ImageEqualizer(),
        );
      },
    );
  }
}

class ImageEqualizer extends StatefulWidget {
  const ImageEqualizer({super.key});

  @override
  _ImageEqualizerState createState() => _ImageEqualizerState();
}

class _ImageEqualizerState extends State<ImageEqualizer> {
  double imageStrength = 0.35;
  int cfgScale = 7;
  int steps = 50;
  String? stylePreset;

  Map<String, String?> stylePresetMap = {
    "None": null,
    "Enhance": "enhance",
    "Anime": "anime",
    "Photographic": "photographic",
    "Digital Art": "digital-art",
    "Comic Book": "comic-book",
    "Fantasy Art": "fantasy-art",
    "Line Art": "line-art",
    "Analog Film": "analog-film",
    "Neon Punk": "neon-punk",
    "Isometric": "isometric",
    "Low Poly": "low-poly",
    "Origami": "origami",
    "Modeling Compound": "modeling-compound",
    "Cinematic": "cinematic",
    "3D Model": "3d-model",
    "Pixel Art": "pixel-art",
    "Tile Texture": "tile-texture",
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageStrength =
          (prefs.getDouble(ImageEqSharedPrefKeys.imageStrength) ?? 0.35);
      cfgScale = (prefs.getInt(ImageEqSharedPrefKeys.cfgScale) ?? 7);
      steps = (prefs.getInt(ImageEqSharedPrefKeys.steps) ?? 50).toInt();
      stylePreset = (prefs.getString(ImageEqSharedPrefKeys.stylePreset));
    });
  }

  _savePreferences(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                '${translate('imageStrength')} (${imageStrength.toStringAsFixed(2)})'),
            const SizedBox(height: 5),
            Text(translate('howSimilar'),
                style: Theme.of(context).textTheme.labelMedium),
            Slider(
              value: imageStrength,
              min: 0,
              max: 1,
              onChanged: (newValue) {
                setState(() {
                  imageStrength = newValue;
                  _savePreferences(
                      ImageEqSharedPrefKeys.imageStrength, newValue);
                });
              },
            ),
            Text('${translate('cfgScale')} ($cfgScale)'),
            const SizedBox(height: 5),
            Text(translate('strictOutput'),
                style: Theme.of(context).textTheme.labelMedium),
            Slider(
              value: cfgScale.toDouble(),
              min: 0,
              max: 35,
              onChanged: (newValue) {
                setState(() {
                  cfgScale = newValue.round();
                  _savePreferences(
                      ImageEqSharedPrefKeys.cfgScale, newValue.toInt());
                });
              },
            ),
            Text('${translate('steps')} ($steps)'),
            const SizedBox(height: 5),
            Text(translate('higherValues'),
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 5),
            Text(translate('lowerValues'),
                style: Theme.of(context).textTheme.labelMedium),
            Slider(
              value: steps.toDouble(),
              min: 10,
              max: 150,
              onChanged: (newValue) {
                setState(() {
                  steps = newValue.toInt();
                  _savePreferences(
                      ImageEqSharedPrefKeys.steps, newValue.toInt());
                });
              },
            ),
            const SizedBox(height: 10),
            Text(translate('stylePreset')),
            DropdownButton<String>(
              hint: Text(translate('outputStyle')),
              value: stylePresetMap.entries
                  .firstWhere((element) => element.value == stylePreset)
                  .key,
              onChanged: (String? newKey) {
                setState(() {
                  stylePreset = stylePresetMap[newKey];
                  _savePreferences(
                      ImageEqSharedPrefKeys.stylePreset, stylePreset);
                });
              },
              items: stylePresetMap.keys
                  .map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
