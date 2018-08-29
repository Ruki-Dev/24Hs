// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// An example of using the plugin, controlling lifecycle and playback of the
/// video.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Videos.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

/// Controls play and pause of [controller].
///
/// Toggles play/pause on tap (accompanied by a fading status icon).
///
/// Plays (looping) on initialization, and mutes on deactivation.
class VideoPlayPause extends StatefulWidget {
  final VideoPlayerController controller;
  final Videos videos;
  final VoidCallback onDoubleTap;
  final bool preview;
  final bool fullPlayer;

  VideoPlayPause(this.controller,
      {this.videos,
      this.preview = false,
      this.fullPlayer: false,
      this.onDoubleTap});

  @override
  State createState() {
    return new _VideoPlayPauseState();
  }
}

class _VideoPlayPauseState extends State<VideoPlayPause>
    with TickerProviderStateMixin {
  FadeAnimation imageFadeAnim =
      new FadeAnimation(child: const Icon(Icons.play_arrow, size: 80.0));
  AnimationController animationController;
  VoidCallback listener;
  FadeAnimation rewindFade, ffFade;

  _VideoPlayPauseState() {
    listener = () {
      setState(() {
        if (controller.value.position.inMilliseconds ==
            controller.value.duration.inMilliseconds - 1) {
          isDone = true;

          isTapped = true;
        }
      });
    };
  }

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    controller.setVolume(1.0);
    controller.play();
  }

  var durStyle = TextStyle(fontSize: 12.0, color: Colors.white70);

  @override
  void deactivate() {
    //controller.setVolume(0.0);
    controller.removeListener(listener);
    super.deactivate();
  }

  Widget controls_overlay() {
    return GestureDetector(
        onTapUp: _handleLeft,
        onTap: () {
          if (isTapped) {
            setState(() {
              isTapped = true;
            });
            print("TAPPED***: $isTapped");
            isTapped = false;
          } else {
            setState(() {
              isTapped = false;
            });
            print("isTapped***: $isTapped");
            isTapped = true;
          }
        },
        child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.black54),
            // child: Column(
            //children: <Widget>[
            child: new Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                overflow: Overflow.clip,
                children: <Widget>[
                  new Align(
                      alignment: Alignment.topCenter,
                      child: new Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    width: 100.0,
                                    child: Text(
                                      widget.videos.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize:
                                              widget.videos.title.length >= 32
                                                  ? 12.0
                                                  : 16.0),
                                    )),
                                IconButton(
                                    icon: Icon(
                                  Icons.share,
                                  color: Colors.white70,
                                )),
                                IconButton(
                                    icon: Icon(
                                  Icons.file_download,
                                  color: Colors.white70,
                                )),
                              ]))),
                  new Align(
                      alignment: Alignment.bottomCenter,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Padding(
                                padding: new EdgeInsets.only(left: 16.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      current_time,
                                      style: durStyle,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          widget.fullPlayer
                                              ? Navigator.pop(context)
                                              : widget.onDoubleTap;
                                        },
                                        icon: Icon(
                                          widget.fullPlayer
                                              ? Icons.fullscreen_exit
                                              : Icons.fullscreen,
                                          color: Colors.white70,
                                        )),
                                    Text(
                                      '${controller.value.duration
                                        .inMinutes}: ${(controller.value
                                        .duration.inSeconds % 60) < 10 ? '0' +
                                        (controller.value.duration.inSeconds %
                                            60).toString() : controller.value
                                        .duration.inSeconds % 60}',
                                      style: durStyle,
                                    )
                                  ],
                                )),
                            new VideoProgressIndicator(
                              controller,
                              colors: VideoProgressColors(
                                  playedColor: Colors.midnightTextPrimary,
                                  bufferedColor: Colors.blueGrey,
                                  backgroundColor: Colors.black87),
                              allowScrubbing: true,
                              padding: isTapped
                                  ? const EdgeInsets.all(16.0)
                                  : new EdgeInsets.only(top: (5.toDouble())),
                            ),
                          ])),
                  Align(
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              onPressed: () {
                                controller.value.position.inMilliseconds >= 10
                                    ? controller.seekTo(Duration(
                                        seconds: controller
                                                .value.position.inSeconds -
                                            10))
                                    : null;
                              },
                              mini: true,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.fast_rewind,
                                color: Colors.white70,
                              ),
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.white30,
                              child: isDone
                                  ? Icon(
                                      Icons.replay,
                                      color: Colors.white70,
                                    )
                                  : AnimatedIcon(
                                      icon: isPlaying
                                          ? AnimatedIcons.pause_play
                                          : AnimatedIcons.play_pause,
                                      color: Colors.white,
                                      size: 50.0,
                                      progress: animationController),
                              onPressed: () {
                                if (controller.value.isPlaying) {
                                  isPlaying = false;

                                  controller.pause();
                                  isTapped = true;
                                } else {
                                  isPlaying = true;
                                  isTapped = false;
                                  if (isDone) {
                                    controller.seekTo(Duration(seconds: 0));
                                    controller.play();
                                  } else
                                    controller.play();
                                }
                              },
                            ),
                            FloatingActionButton(
                              mini: true,
                              onPressed: () {
                                controller.value.position.inMilliseconds <=
                                        controller.value.duration.inSeconds - 10
                                    ? controller.seekTo(Duration(
                                        seconds: controller
                                                .value.position.inSeconds +
                                            10))
                                    : null;
                              },
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.fast_forward,
                                color: Colors.white70,
                              ),
                            ),
                          ]))
                ])
            // ]
            // )
            ));
  }

  bool isTapped = false;
  bool isPlaying = true;
  bool isDone = false;
  Offset _tapPosition;

  void _handleLeft(TapUpDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
      print('${_tapPosition.distance}');
    });
  }

  var ms = const Duration(milliseconds: 1);
  var dur = const Duration(milliseconds: 3);

  startTimeout([int millis = 1000]) {
    print('ojbv');

    var duration = millis == null ? dur : ms * millis;
    print(duration);
    var tm = Timer(duration, handleTimeout);

    return tm;
  }

  handleTimeout() {
    if (!isPlaying)
      setState(() {
        isTapped = true;
      });
    else
      setState(() {
        isTapped = false;
      });
  }

  String current_time;
  int duration;
  int position;

  @override
  Widget build(BuildContext context) {
    current_time =
        '${controller.value.position.inMinutes}: ${(controller.value.position
        .inSeconds % 60) < 10 ? '0' +
        (controller.value.position.inSeconds % 60).toString() : controller.value
        .position.inSeconds % 60}';
    duration = controller.value.duration.inMilliseconds;
    position = controller.value.position.inMilliseconds;
    final List<Widget> children = <Widget>[
      new GestureDetector(
          onTap: widget.preview
              ? () {
                  if (!controller.value.initialized) {
                    return;
                  }
                  if (controller.value.isPlaying) {
                    imageFadeAnim = new FadeAnimation(
                        child: const Icon(Icons.pause, size: 100.0));
                    controller.pause();
                  } else {
                    imageFadeAnim = new FadeAnimation(
                        child: const Icon(Icons.play_arrow, size: 100.0));
                    controller.play();
                  }
                }
              : () {
                  startTimeout(2000);
                  if (isTapped) {
                    setState(() {
                      isTapped = true;
                    });
                    print("TAPPED***: $isTapped");
                    isTapped = false;
                  } else {
                    setState(() {
                      isTapped = false;
                    });
                    print("isTapped***: $isTapped");
                    isTapped = true;
                  }
                },
          child: new Stack(children: <Widget>[
            new VideoPlayer(controller),
            /* onTap: () {
          if (!controller.value.initialized) {
            return;
          }
          if (controller.value.isPlaying) {
            imageFadeAnim =
            new FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
            controller.pause();
          } else {
            imageFadeAnim = new FadeAnimation(
                child: const Icon(Icons.play_arrow, size: 100.0));
            controller.play();
          }
        }*/
          ])),
      new Align(
          alignment: Alignment.bottomCenter,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.only(
                        left: position / duration.toDouble()),
                    child: new Tooltip(
                      message: current_time,
                    )),
                widget.fullPlayer
                    ? new Container()
                    : new VideoProgressIndicator(
                        controller,
                        colors: VideoProgressColors(
                            playedColor: Colors.lightBlue,
                            bufferedColor: Colors.blueGrey,
                            backgroundColor: Colors.black87),
                        allowScrubbing: true,
                        padding: isTapped
                            ? const EdgeInsets.all(16.0)
                            : new EdgeInsets.only(top: (5.toDouble())),
                      ),
              ])),
      //Rewind 10
      widget.preview
          ? new Container()
          : new Align(
              alignment: Alignment.centerLeft,
              child: new GestureDetector(
                  onDoubleTap: () {
                    controller.value.position.inMilliseconds >= 10
                        ? controller.seekTo(Duration(
                            seconds: controller.value.position.inSeconds - 10))
                        : null;
                    ffFade = FadeAnimation(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.fast_rewind,
                            color: Colors.white70,
                          ),
                          Text('10 seconds',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    );
                  },
                  onTap: () {
                    startTimeout(2000);
                    if (isTapped) {
                      setState(() {
                        isTapped = true;
                      });
                      print("TAPPED***: $isTapped");
                      isTapped = false;
                    } else {
                      setState(() {
                        isTapped = false;
                      });
                      print("isTapped***: $isTapped");
                      isTapped = true;
                    }
                  },
                  child: new AspectRatio(
                      aspectRatio: controller.value.aspectRatio / 2,
                      child: Container(color: Colors.transparent))),
            ),
      widget.preview
          ? new Container()
          : new Align(
              alignment: Alignment.centerRight,
              child: new GestureDetector(
                  onDoubleTap: () {
                    controller.seekTo(Duration(
                        seconds: controller.value.position.inSeconds + 10));
                    rewindFade = FadeAnimation(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.fast_forward,
                            color: Colors.white70,
                          ),
                          Text(
                            '10 seconds',
                            style: TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    );
                  },
                  onTap: () {
                    startTimeout(2000);
                    if (isTapped) {
                      setState(() {
                        isTapped = true;
                      });
                      print("TAPPED***: $isTapped");
                      isTapped = false;
                    } else {
                      setState(() {
                        isTapped = false;
                      });
                      print("isTapped***: $isTapped");
                      isTapped = true;
                    }
                  },
                  child: new AspectRatio(
                      aspectRatio: controller.value.aspectRatio / 2,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(child: ffFade),
                      ))),
            ),
      new Center(
          child: widget.preview
              ? new Center(child: imageFadeAnim)
              : isTapped || isDone ? controls_overlay() : new Container()),

      new Center(
          child: controller.value.isBuffering
              ? const CircularProgressIndicator()
              : null),
    ];

    return new Stack(
      fit: StackFit.passthrough,
      children: children,
    );
  }
}

class RippleAnim extends StatefulWidget {
  final Widget child;
  final Duration duration;

  RippleAnim({this.duration, this.child});

  _RippleAnimState createState() => _RippleAnimState();
}

class _RippleAnimState extends State<RippleAnim> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        new AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(RippleAnim oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return animationController.isAnimating
        ? new Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : new Container();
  }
}

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  FadeAnimation(
      {this.child, this.duration: const Duration(milliseconds: 1200)});

  @override
  _FadeAnimationState createState() => new _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        new AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? new Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : new Container();
  }
}

typedef Widget VideoWidgetBuilder(
    BuildContext context, VideoPlayerController controller);

abstract class PlayerLifeCycle extends StatefulWidget {
  final VideoWidgetBuilder childBuilder;
  final String dataSource;

  PlayerLifeCycle(this.dataSource, this.childBuilder);
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// a data source from the network.
class NetworkPlayerLifeCycle extends PlayerLifeCycle {
  NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _NetworkPlayerLifeCycleState createState() =>
      new _NetworkPlayerLifeCycleState();
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// an asset as data source
class AssetPlayerLifeCycle extends PlayerLifeCycle {
  AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _AssetPlayerLifeCycleState createState() => new _AssetPlayerLifeCycleState();
}

abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
  VideoPlayerController controller;

  @override

  /// Subclasses should implement [createVideoPlayerController], which is used
  /// by this method.
  void initState() {
    super.initState();
    controller = createVideoPlayerController();
    controller.addListener(() {
      if (controller.value.hasError) {
        print(controller.value.errorDescription);
      }
    });
    controller.initialize();
    controller.setLooping(true);
    controller.play();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(context, controller);
  }

  VideoPlayerController createVideoPlayerController();
}

class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.network(widget.dataSource);
  }
}

class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.asset(widget.dataSource);
  }
}

/// A filler card to show the video in a list of scrolling contents.
Widget buildCard(String title) {
  return new Card(
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.airline_seat_flat_angled),
          title: new Text(title),
        ),
        new ButtonTheme.bar(
          child: new ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
              new FlatButton(
                child: const Text('SELL TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class VideoInListOfCards extends StatelessWidget {
  final VideoPlayerController controller;

  VideoInListOfCards(this.controller);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        buildCard("Item a"),
        buildCard("Item b"),
        buildCard("Item c"),
        buildCard("Item d"),
        buildCard("Item e"),
        buildCard("Item f"),
        buildCard("Item g"),
        new Card(
            child: new Column(children: <Widget>[
          new Column(
            children: <Widget>[
              const ListTile(
                leading: const Icon(Icons.cake),
                title: const Text("Video video"),
              ),
              new Stack(
                  alignment: FractionalOffset.bottomRight +
                      const FractionalOffset(-0.1, -0.1),
                  children: <Widget>[
                    new AspectRatioVideo(controller),
                    new Image.asset('assets/flutter-mark-square-64.png'),
                  ]),
            ],
          ),
        ])),
        buildCard("Item h"),
        buildCard("Item i"),
        buildCard("Item j"),
        buildCard("Item k"),
        buildCard("Item l"),
      ],
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  final VideoPlayerController controller;

  AspectRatioVideo(this.controller);

  @override
  AspectRatioVideoState createState() => new AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      final Size size = controller.value.size;
      return new Center(
        child: new AspectRatio(
          aspectRatio: size.width / size.height,
          child: new VideoPlayPause(controller),
        ),
      );
    } else {
      return new Container();
    }
  }
}

void main() {
  runApp(
    new MaterialApp(
      home: new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('Video player example'),
            bottom: const TabBar(
              isScrollable: true,
              tabs: const <Widget>[
                const Tab(icon: const Icon(Icons.fullscreen)),
                const Tab(icon: const Icon(Icons.list)),
              ],
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new NetworkPlayerLifeCycle(
                    'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4',
                    (BuildContext context, VideoPlayerController controller) =>
                        new AspectRatioVideo(controller),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new NetworkPlayerLifeCycle(
                    'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
                    (BuildContext context, VideoPlayerController controller) =>
                        new AspectRatioVideo(controller),
                  ),
                ],
              ),
              new NetworkPlayerLifeCycle(
                'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4',
                (BuildContext context, VideoPlayerController controller) =>
                    new AspectRatioVideo(controller),
              ),
              new AssetPlayerLifeCycle(
                  'assets/Butterfly-209.mp4',
                  (BuildContext context, VideoPlayerController controller) =>
                      new VideoInListOfCards(controller)),
            ],
          ),
        ),
      ),
    ),
  );
}
