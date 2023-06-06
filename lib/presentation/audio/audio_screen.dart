import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  String? _path;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isProcessing = false;
  final List<String> _audioPaths = [];
  final Map<String, Duration> _audioDurations = {};
  final Map<String, Duration> _audioProgress = {};
  final List<String> _processedFiles = [];
  final _urlController = TextEditingController();

  Future _processAndUploadYoutubeUrl() async {
    setState(() {
      _isProcessing = true;
    });

    var response = await http.post(
      Uri.parse(
          'https://6af2-2800-2261-4000-52b-a9e3-ed38-1053-d84a.ngrok-free.app/v1/unmix_youtube'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': _urlController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Uploaded!');

      // Download the ZIP file

      var bytes = response.bodyBytes;

      // Get the temporary directory to save the ZIP file
      var tempDir = await getTemporaryDirectory();
      var zipFilePath = '${tempDir.path}/audio_separated.zip';
      var file = File(zipFilePath);
      await file.writeAsBytes(bytes);

      print('ZIP file saved to $zipFilePath');

      // Extract the ZIP file
      var outputDirPath = '${tempDir.path}/audio_separated';
      var outputDir = Directory(outputDirPath);
      await ZipFile.extractToDirectory(
        zipFile: file,
        destinationDir: outputDir,
      );

      print('ZIP file extracted to $outputDirPath');

      // Get the paths of the separated audio files
      var separatedAudioPaths = outputDir
          .listSync(recursive: true)
          .whereType<File>()
          .map((entity) => entity.path)
          .toList();

      print('Separated audio paths: $separatedAudioPaths');

      // Add the separated audio paths to _audioPaths
      setState(() {
        _processedFiles.addAll(separatedAudioPaths);
        _audioPaths.addAll(separatedAudioPaths);

        _isProcessing = false;
      });
    } else {
      print('Failed to upload.');
    }
  }

  void _showYoutubeUrlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Youtube URL'),
          content: TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              hintText: 'Youtube URL',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                _processAndUploadYoutubeUrl();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    if (!await Permission.microphone.isGranted) {
      await Permission.microphone.request();
    }

    await _recorder.openRecorder();
    await _player.openPlayer();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  Future _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String path =
        '$tempPath/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
    );
    setState(() {
      _isRecording = true;
      _path = path;
    });
  }

  Future _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _audioPaths.add(_path!); // add the path of recorded file to the list
      _path = '';
    });
  }

  Future _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['aac', 'mp3', 'wav'], // add more if needed
    );

    if (result != null) {
      _path = result.files.single.path;

      setState(() {
        _audioPaths.add(_path!);
      });
    } else {
      // User canceled the picker
    }
  }

  Future _processAndUploadFile(String path) async {
    setState(() {
      _isProcessing = true;
    });
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://6af2-2800-2261-4000-52b-a9e3-ed38-1053-d84a.ngrok-free.app/v1/unmix'),
    );

    request.files.add(await http.MultipartFile.fromPath('audio', path));
    request.headers['connection'] = 'keep-alive';
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded!');

      // Download the ZIP file
      var httpResponse = await http.Response.fromStream(
        response,
      );
      var bytes = httpResponse.bodyBytes;

      // Get the temporary directory to save the ZIP file
      var tempDir = await getTemporaryDirectory();
      var zipFilePath = '${tempDir.path}/audio_separated.zip';
      var file = File(zipFilePath);
      await file.writeAsBytes(bytes);

      print('ZIP file saved to $zipFilePath');

      // Extract the ZIP file
      var outputDirPath = '${tempDir.path}/audio_separated';
      var outputDir = Directory(outputDirPath);
      await ZipFile.extractToDirectory(
        zipFile: file,
        destinationDir: outputDir,
      );

      print('ZIP file extracted to $outputDirPath');

      // Get the paths of the separated audio files
      var separatedAudioPaths = outputDir
          .listSync(recursive: true)
          .whereType<File>()
          .map((entity) => entity.path)
          .toList();

      print('Separated audio paths: $separatedAudioPaths');

      // Add the separated audio paths to _audioPaths
      setState(() {
        _processedFiles.addAll(separatedAudioPaths);
        _audioPaths.addAll(separatedAudioPaths);
        _processedFiles.add(path);
        _isProcessing = false;
      });
    } else {
      print('Failed to upload.');
    }
  }

  Future _startPlaying(String path) async {
    var extension = p.extension(path);
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
      default:
        throw UnsupportedError('Unsupported file extension: $extension');
    }

    await _player.startPlayer(
      fromURI: path,
      codec: codec,
      whenFinished: () {
        setState(() {
          _isPlaying = false;
        });
      },
    );
    await _player.setSubscriptionDuration(const Duration(milliseconds: 100));
    if (_player.onProgress != null) {
      _player.onProgress!.listen((event) {
        setState(() {
          _audioProgress[path] = event.position;

          _audioDurations[path] = event.duration;
        });
      });
    }

    setState(() {
      _isPlaying = true;
      _path = path;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recorder and Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _audioPaths.length,
                itemBuilder: (context, index) {
                  final path = _audioPaths[index];
                  return AudioTile(
                    path: path,
                    onPlay: () => _startPlaying(path),
                    onStop: _stopPlaying,
                    onProcess: () => _processAndUploadFile(path),
                    onShare: () => Share.shareFiles([path]),
                    isPlaying: _isPlaying && _path == path,
                    isProcessed: _processedFiles.contains(path),
                    duration: _audioDurations[path] ?? Duration.zero,
                    progress: _audioProgress[path] ?? Duration.zero,
                    isProcessing: _isProcessing,
                  );
                },
              ),
            ),
            SizedBox(
              height: 26,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  switch (index) {
                    case 0:
                      return TextButton(
                        onPressed: !_isProcessing
                            ? _isRecording
                                ? _stopRecording
                                : _startRecording
                            : () {},
                        child: Text(_isRecording
                            ? 'Stop Recording'
                            : 'Start Recording'),
                      );
                    case 1:
                      return TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed:
                            !_isProcessing ? _showYoutubeUrlDialog : () {},
                        child: Text(!_isProcessing
                            ? 'From YouTube URL'
                            : 'It will take a while'),
                      );
                    case 2:
                      return TextButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                        onPressed: !_isProcessing ? _selectFile : () {},
                        child: Text(
                            !_isProcessing ? 'Select File' : 'Processing...'),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AudioTile extends StatelessWidget {
  final String path;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onProcess;
  final VoidCallback onShare;
  final bool isPlaying;
  final bool isProcessed;
  final Duration duration;
  final Duration progress;
  final bool isProcessing;

  const AudioTile({
    Key? key,
    required this.path,
    required this.onPlay,
    required this.onStop,
    required this.onProcess,
    required this.onShare,
    required this.isPlaying,
    required this.isProcessed,
    required this.duration,
    required this.progress,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(p.basename(path)),
              IconButton(
                onPressed: onShare,
                icon: const Icon(Icons.share),
              ),
            ],
          ),
          Column(
            children: [
              Divider(
                color: Theme.of(context).colorScheme.secondary,
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${progress.inMinutes}:${(progress.inSeconds % 60).toString().padLeft(2, '0')}',
                  ),
                  Text(
                    '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  ),
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: isPlaying ? onStop : onPlay,
                child: Text(isPlaying ? 'Stop Playing' : 'Start Playing'),
              ),
              if (!isProcessed && !isProcessing)
                OutlinedButton(
                    onPressed: !isProcessing ? onProcess : () {},
                    child: const Text('Process')),
              if (isProcessing)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider()
        ],
      ),
    );
  }
}
