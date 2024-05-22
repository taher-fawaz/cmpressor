import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:compressor/compressor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> initPlatformState(String videoPath) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/compressed_videos';
    await Directory(dirPath).create(recursive: true);
    final String compressedPath = '$dirPath/compressed_video.mp4';
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Compressor.trimVideo(videoPath, compressedPath, 60, 120)
              // await Compressor.compressVideo(videoPath, compressedPath)
              ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    setState(() {
      _platformVersion = platformVersion!;
    });
    return _platformVersion;
  }

  @override
  void didChangeDependencies() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_platformVersion),
            TextButton(
                onPressed: () async {
                  final String t = await initPlatformState(
                      "/storage/emulated/0/Download/7mins.mp4");

                  // await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => VideoApp(file: File(t)),
                  //     ));
                },
                child: Text("Compress Video")),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoApp(file: File(_platformVersion)),
                      ));
                },
                child: Text("show Video")),
            // if (_platformVersion != null || _platformVersion.isNotEmpty)
            // VideoApp(file: File(_platformVersion))
          ],
        ),
      ),
    );
  }
}

class VideoApp extends StatefulWidget {
  final File file;
  const VideoApp({super.key, required this.file});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
