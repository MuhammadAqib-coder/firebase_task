import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class VideosView extends StatefulWidget {
  const VideosView({super.key});

  @override
  State<VideosView> createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Videos'),
            actions: [
              IconButton(
                  onPressed: () {
                    // Navigator.push<_Playe>(context, route);
                  },
                  icon: Icon(Icons.navigation))
            ],
            bottom: const TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(Icons.cloud),
                    text: "Remote",
                  ),
                  Tab(
                    icon: Icon(Icons.insert_drive_file),
                    text: 'Assets',
                  ),
                  Tab(
                    icon: Icon(Icons.list),
                    text: 'List',
                  )
                ]),
          ),
          body: const TabBarView(children: [
            BumbleBeeRemoteVideo(),
            ButterFlyAssetVideo(),
            ButterFlyAssetVideoInList(),
          ]),
        ));
  }
}

class ButterFlyAssetVideoInList extends StatelessWidget {
  const ButterFlyAssetVideoInList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ExampleCard(title: 'Item a'),
        const ExampleCard(title: 'Item b'),
        const ExampleCard(title: 'Item c'),
        const ExampleCard(title: 'Item d'),
        const ExampleCard(title: 'Item e'),
        const ExampleCard(title: 'Item f'),
        const ExampleCard(title: 'Item g'),
        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.cake),
                title: Text("video Cake"),
              ),
              Stack(
                alignment: FractionalOffset.bottomRight +
                    const FractionalOffset(-0.1, -0.1),
                children: [
                  ButterFlyAssetVideo(),
                ],
              )
            ],
          ),
        ),
        const ExampleCard(title: 'Item h'),
        const ExampleCard(title: 'Item i'),
        const ExampleCard(title: 'Item j'),
        const ExampleCard(title: 'Item k'),
        const ExampleCard(title: 'Item l'),
      ],
    );
  }
}

class ExampleCard extends StatelessWidget {
  const ExampleCard({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.airline_seat_flat_angled),
            title: Text(title),
          ),
          ButtonBar(
            children: [
              TextButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
              TextButton(
                child: const Text('SELL TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ButterFlyAssetVideo extends StatefulWidget {
  const ButterFlyAssetVideo({super.key});

  @override
  State<ButterFlyAssetVideo> createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<ButterFlyAssetVideo> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BumbleBeeRemoteVideo extends StatefulWidget {
  const BumbleBeeRemoteVideo({super.key});

  @override
  State<BumbleBeeRemoteVideo> createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<BumbleBeeRemoteVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _controller.addListener(() {});
    _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(padding: const EdgeInsets.only(top: 20.0)),
          const Text('With remote mp4'),
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_controller),
                  ClosedCaption(
                    text: _controller.value.caption.text,
                  ),
                  ControlsOverlay(
                    controller: _controller,
                  ),
                  VideoProgressIndicator(_controller, allowScrubbing: true)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({super.key, required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          // reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black,
                  child: const Center(
                      child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    semanticLabel: "play",
                    size: 100,
                  )),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            color: Colors.white,
            initialValue: controller.value.captionOffset,
            tooltip: 'captionOffset',
            onSelected: (value) {
              controller.setCaptionOffset(value);
            },
            itemBuilder: (cntext) {
              return <PopupMenuItem<Duration>>[
                for (var offSet in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                      value: offSet, child: Text('${offSet.inMilliseconds}ms'))
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
