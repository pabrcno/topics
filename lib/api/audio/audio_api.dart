import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../domain/api/audio/i_audio_api.dart';

class AudioApi implements IAudioApi {
  final String fileUrl =
      'https://6af2-2800-2261-4000-52b-a9e3-ed38-1053-d84a.ngrok-free.app/v1/unmix';
  final String youtubeUrl =
      'https://6af2-2800-2261-4000-52b-a9e3-ed38-1053-d84a.ngrok-free.app/v1/unmix_youtube';

  @override
  Stream<String> processAndUploadFile(String path) async* {
    var request = http.MultipartRequest('POST', Uri.parse(fileUrl));
    request.files.add(await http.MultipartFile.fromPath('audio', path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    await for (var filePath in _processResponse(response)) {
      yield filePath;
    }
  }

  @override
  Stream<String> processAndUploadYoutubeUrl(String youtubeUrl) async* {
    var response = await http.post(
      Uri.parse(this.youtubeUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': youtubeUrl,
      }),
    );
    await for (var filePath in _processResponse(response)) {
      yield filePath;
    }
  }

  Stream<String> _processResponse(http.Response response) async* {
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var fileNames = responseData['files'] as List<String>;
      await for (var filePath in _downloadFiles(fileNames)) {
        yield filePath;
      }
    } else {
      throw Exception('Failed to upload.');
    }
  }

  Stream<String> _downloadFiles(List<String> fileNames) async* {
    var tempDir = await getTemporaryDirectory();
    for (var filename in fileNames) {
      var response = await http
          .get(Uri.parse('https://your-server-url.com/download/$filename'));
      if (response.statusCode == 200) {
        var downloadPath = '${tempDir.path}/$filename';
        var file = File(downloadPath);
        await file.writeAsBytes(response.bodyBytes);
        yield downloadPath;
      } else {
        throw Exception('Failed to download file: $filename');
      }
    }
  }
}
