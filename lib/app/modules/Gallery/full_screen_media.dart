import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenMedia extends StatefulWidget {

  final String url;

  const FullScreenMedia({super.key, required this.url});

  @override
  State<FullScreenMedia> createState() => _FullScreenMediaState();
}

class _FullScreenMediaState extends State<FullScreenMedia> {

  VideoPlayerController? controller;

  bool isVideo = false;

  @override
  void initState() {
    super.initState();

    if (widget.url.endsWith(".mp4") ||
        widget.url.endsWith(".mov") ||
        widget.url.endsWith(".avi")) {

      isVideo = true;

      controller = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
          controller!.play();
        });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),

      body: Center(

        child: isVideo
            ? controller != null && controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  )
                : const CircularProgressIndicator()
            : InteractiveViewer(
                child: Image.network(widget.url),
              ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}