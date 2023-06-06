import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:topics/domain/api/audio/i_audio_api.dart';

class AudioProvider with ChangeNotifier {
  final IAudioApi _audioApi;
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
  final urlController = TextEditingController();

  // provide getters to expose the private fields to the UI.
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  bool get isProcessing => _isProcessing;
  List<String> get audioPaths => _audioPaths;
  Map<String, Duration> get audioDurations => _audioDurations;
  Map<String, Duration> get audioProgress => _audioProgress;
  List<String> get processedFiles => _processedFiles;

  AudioProvider(this._audioApi);

  String? get path => _path;
  set path(String? value) {
    _path = value;
    notifyListeners();
  }

  set isProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  set isRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }

  Future<void> init() async {
    if (!await Permission.microphone.isGranted) {
      await Permission.microphone.request();
    }

    await _recorder.openRecorder();
    await _player.openPlayer();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _recorder.closeRecorder();
    _player.closePlayer();
    notifyListeners();
  }

  Future startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String path =
        '$tempPath/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
    );

    isRecording = true;
    path = path;
  }

  Future stopRecording() async {
    await _recorder.stopRecorder();
    isRecording = false;
    _audioPaths.add(_path!);
    await _player.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
    _audioProgress[_path!] = Duration.zero;
    notifyListeners();
  }

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'], // add more if needed
    );

    if (result != null) {
      _path = result.files.single.path;

      _audioPaths.add(_path!);
    } else {
      // User canceled the picker
    }
    notifyListeners();
  }

  Future<void> processAndUploadFile(String path) async {
    isProcessing = true;
    final processed = await _audioApi.processAndUploadFile(path);
    audioPaths.addAll(processed);
    processedFiles.addAll(processed);

    isProcessing = false;
    notifyListeners();
  }

  Future<void> processAndUploadYoutubeUrl() async {
    isProcessing = true;
    final processed =
        await _audioApi.processAndUploadYoutubeUrl(urlController.text);
    audioPaths.addAll(processed);
    processedFiles.addAll(processed);
    isProcessing = false;
    notifyListeners();
  }

  Future startPlaying(String path) async {
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
    await _player.openPlayer();
    await _player.startPlayer(
      fromURI: path,
      codec: codec,
      whenFinished: () {
        isPlaying = false;
        notifyListeners();
      },
    );
    await _player.setSubscriptionDuration(const Duration(milliseconds: 100));
    if (_player.onProgress != null) {
      _player.onProgress!.listen((event) {
        _audioProgress[path] = event.position;
        _audioDurations[path] = event.duration;
        notifyListeners();
      });
    }

    isPlaying = true;
    _path = path;
    notifyListeners();
  }

  Future stopPlaying() async {
    await _player.stopPlayer();
    isPlaying = false;
    notifyListeners();
  }
}
