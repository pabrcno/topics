import 'dart:convert';
import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../domain/api/audio/i_audio_api.dart';

class AudioApi implements IAudioApi {
  final audioUrl = dotenv.env['AUDIO_URL']!;

  @override
  Future<List<String>> processAndUploadFile(String path) async {
    final String fileUrl = '$audioUrl/v1/unmix';
    var request = http.MultipartRequest('POST', Uri.parse(fileUrl));
    request.files.add(await http.MultipartFile.fromPath('audio', path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    return _processResponse(response);
  }

  @override
  Future<List<String>> processAndUploadYoutubeUrl(String youtubeUrl) async {
    final String youtubeUrl = '$audioUrl/v1/unmix_youtube';

    var response = await http.post(
      Uri.parse(youtubeUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': youtubeUrl,
      }),
    );
    return _processResponse(response);
  }

  Future<List<String>> _processResponse(http.Response response) async {
    if (response.statusCode == 200) {
      print('Uploaded!');
      // Process the response and extract audio files
      return await _processAndExtractResponse(response);
    } else {
      print('Failed to upload.');

      return [];
    }
  }

  Future<List<String>> _processAndExtractResponse(
      http.Response response) async {
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

    return separatedAudioPaths;
  }
}
