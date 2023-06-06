import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as p;

class AudioPlayer extends StatefulWidget {
  final String audioPath;

  const AudioPlayer(Key key, {required this.audioPath}) : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.openPlayer().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _player.closePlayer();

    super.dispose();
  }

  Future _startPlaying() async {
    // Use the 'path' package to get the file extension
    var extension = p.extension(widget.audioPath);

    Codec codec;
    switch (extension) {
      case '.mp3':
        codec = Codec.mp3;
        break;
      case '.aac':
        codec = Codec.aacADTS;
        break;
      case '.wav':
        codec = Codec.pcm16WAV;
        break;
      // Add more cases as needed
      default:
        throw UnsupportedError('Unsupported file extension: $extension');
    }

    await _player.startPlayer(
      fromURI: widget.audioPath,
      codec: codec,
    );
    setState(() {
      _isPlaying = true;
    });
  }

  Future _stopPlaying() async {
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _isPlaying ? _stopPlaying : _startPlaying,
      child: Text(_isPlaying ? 'Stop Playing' : 'Start Playing'),
    );
  }
}
