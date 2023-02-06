import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class VideoExample extends StatelessWidget {
  const VideoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video player"),
      ),
      body: ListView(
        children: [
          VideoItem(
              videoPlayerController:
                  VideoPlayerController.asset("assets/videos/flutter.mp4")
                    ..initialize(),
              looping: false,
              autoplay: false),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {}, child: const Text('convert to audio'))
          // VideoItem(
          //     videoPlayerController: VideoPlayerController.network(
          //         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
          //     looping: false,
          //     autoplay: false)
        ],
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  const VideoItem(
      {super.key,
      required this.videoPlayerController,
      required this.looping,
      required this.autoplay});
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        showControls: true,
        videoPlayerController: widget.videoPlayerController,
        looping: widget.looping,
        autoPlay: widget.autoplay,
        allowPlaybackSpeedChanging: true,
        allowFullScreen: true,
        allowMuting: true,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: () => debugPrint('My option works!'),
              iconData: Icons.chat,
              title: 'My localized title',
            ),
            OptionItem(
              onTap: () => debugPrint('Another option working!'),
              iconData: Icons.chat,
              title: 'Another localized title',
            ),
          ];
        },
        optionsBuilder: (context, defaultOptions) async {
          await showDialog<void>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: ListView.builder(
                  itemCount: defaultOptions.length,
                  itemBuilder: (_, i) => ActionChip(
                    label: Text(defaultOptions[i].title),
                    onPressed: () => defaultOptions[i].onTap!(),
                  ),
                ),
              );
            },
          );
        },
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        // autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage),
          );
        });
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
