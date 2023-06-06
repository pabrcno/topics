import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../app/audio/audio_provider.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({Key? key}) : super(key: key);

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
              child: Consumer<AudioProvider>(
                builder: (_, provider, __) {
                  return ListView.builder(
                    itemCount: provider.audioPaths.length,
                    itemBuilder: (context, index) {
                      final path = provider.audioPaths[index];
                      return AudioTile(
                        path: path,
                        onPlay: () => provider.startPlaying(path),
                        onStop: provider.stopPlaying,
                        onProcess: () => provider.processAndUploadFile(path),
                        onShare: () => Share.shareFiles([path]),
                        isPlaying: provider.isPlaying && provider.path == path,
                        isProcessed: provider.processedFiles.contains(path),
                        duration:
                            provider.audioDurations[path] ?? Duration.zero,
                        progress: provider.audioProgress[path] ?? Duration.zero,
                        isProcessing: provider.isProcessing,
                      );
                    },
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
                  return Consumer<AudioProvider>(
                    builder: (_, provider, __) {
                      switch (index) {
                        case 0:
                          return TextButton(
                            onPressed: !provider.isProcessing
                                ? provider.isRecording
                                    ? provider.stopRecording
                                    : provider.startRecording
                                : null,
                            child: Text(provider.isRecording
                                ? 'Stop Recording'
                                : 'Start Recording'),
                          );
                        case 1:
                          return TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: !provider.isProcessing
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Enter Youtube URL'),
                                          content: TextField(
                                            controller: provider.urlController,
                                            decoration: const InputDecoration(
                                              hintText: 'Youtube URL',
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Submit'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                provider
                                                    .processAndUploadYoutubeUrl();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                : null,
                            child: Text(!provider.isProcessing
                                ? 'From YouTube URL'
                                : 'It will take a while'),
                          );
                        case 2:
                          return TextButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            onPressed: !provider.isProcessing
                                ? provider.selectFile
                                : null,
                            child: Text(!provider.isProcessing
                                ? 'Select File'
                                : 'Processing...'),
                          );
                        default:
                          return Container();
                      }
                    },
                  );
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
