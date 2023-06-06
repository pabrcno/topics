import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Recorder extends StatefulWidget {
  const Recorder({super.key});

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _path; // Note the change here
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _recorder.openRecorder().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _recorder.closeRecorder();

    super.dispose();
  }

  Future _startRecording() async {
    String tempDirPath = (await getTemporaryDirectory()).path;
    _path = p.join(tempDirPath, 'flutter_sound-tmp.aac');

    await _recorder.startRecorder(
      toFile: _path,
      codec: Codec.aacADTS,
    );
    setState(() {
      _isRecording = true;
    });
  }

  Future _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future _uploadFile() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://your-backend-url/v1/unmix'));
    request.files.add(await http.MultipartFile.fromPath(
        'audio', _path!)); // Note the change here
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded!');
    } else {
      print('Failed to upload.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MaterialButton(
          onPressed: _isRecording ? _stopRecording : _startRecording,
          child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
        ),
        MaterialButton(
          onPressed: _uploadFile,
          child: const Text('Upload'),
        ),
      ],
    );
  }
}
