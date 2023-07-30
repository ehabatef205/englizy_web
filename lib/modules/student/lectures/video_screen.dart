import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String video;

  const VideoScreen({required this.video, super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _videoPlayerController1;
  ChewieController? chewieController;

  void createChewieController(String path) {
    chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(path)),
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      showOptions: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.video)
      ..initialize().then((_) {
        _createChewieController();
        setState(() {});
      });
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      showOptions: false,
      hideControlsTimer: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chewieController?.dispose();
    _videoPlayerController1!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return chewieController != null &&
            chewieController!.videoPlayerController.value.isInitialized
        ? SizedBox(
            width: size.width,
            height: size.height * 0.25,
            child: Chewie(
              controller: chewieController!,
            ),
          )
        : SizedBox(
            height: 50,
            width: 50,
            child: Text(
              "Loading...",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontSize: 18.0,
              ),
            ),
          );
  }
}
