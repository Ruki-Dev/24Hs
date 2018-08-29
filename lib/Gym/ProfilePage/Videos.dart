import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twenty_four_hours/Widget_Assets/Video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:twenty_four_hours/WidgetTests/VideoPlayer_FG.dart';
import 'package:twenty_four_hours/Gym/Models/Videos.dart' as Vids;

class VideosPage extends StatelessWidget {
  final Profile profile;
  final Profile myProfile;

  VideosPage({this.profile, this.myProfile});

  @override
  Widget build(BuildContext context) {
    return Videos(myProfile: myProfile, profile: profile);
  }
}

class Videos extends StatefulWidget {
  final String title;
  final Profile profile;
  final Profile myProfile;

  Videos({this.profile, this.myProfile, Key key, this.title}) : super(key: key);

  VideosState createState() =>
      new VideosState(myProfile: myProfile, profile: profile);
}

class VideosState extends State<Videos> with TickerProviderStateMixin {
  final Profile profile;
  final Profile myProfile;
  VideoPlayerController _cont;
  TabController tabController;
  PageController pgController;
  bool _isPlaying = true;
  bool _isMute = false;
  bool tapped = false;
  VoidCallback listener;
  VoidCallback smallListner;
  ScrollController _scrollController = new ScrollController();
  List<Widget> pages = [
    VLogs(),
    new Card(
      color: Colors.blue,
    ),
    new Card(
      color: Colors.green,
    ),
    new Card(color: Colors.red)
  ];

  VideosState({this.profile, this.myProfile});

  void _onChanged() {
    setState(() {
      print(tabController.index);
      pgController.animateToPage(tabController.index,
          duration: new Duration(milliseconds: 1200), curve: Curves.elasticIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Build HERE
    return Scaffold(
        body: new NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  backgroundColor: _nameToColor(profile.user.username),
                  bottom: new TabBar(controller: tabController, tabs: <Tab>[
                    new Tab(
                      icon: Icon(Icons.settings_input_svideo),
                      text: 'VLogs',
                    ),
                    new Tab(
                      icon: Icon(FontAwesomeIcons.dumbbell),
                      text: 'My Workouts',
                    ),
                    new Tab(
                      icon: Icon(FontAwesomeIcons.utensilSpoon),
                      text: 'Meal Preps',
                    ),
                    new Tab(
                      icon: Icon(Icons.playlist_play),
                      text: 'PlayLists',
                    ),
                  ]),
                  expandedHeight: 256.0,
                  pinned: true,
                  floating: true,
                  snap: true,
                  actions: <Widget>[],
                  flexibleSpace: new FlexibleSpaceBar(
                      title: Text(
                        'My Intro Video',
                        textAlign: TextAlign.end,
                        style: new TextStyle(
                            color: Colors.white30,
                            fontSize: 20.0,
                            fontFamily: 'Galada'),
                      ),
                      background:
                          new Stack(fit: StackFit.expand, children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.alphaBlend(
                                  _nameToColor(profile.user.username),
                                  Colors.black54)),
                        ),
                        MyVidIntro(),
                      ])),
                ),
              ];
            },
            body:
                /*PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pgController,
          onPageChanged: (page){setState(() {

          });},
          itemBuilder: (context,index){
            return new Center(//Change to cutom load animation
             child: pages[index],

            );
          },
          itemCount: pages.length,
        ),*/

                TabBarView(
              controller: tabController,
              children: <Widget>[
                VLogs(
                  profile: profile,
                  myProfile: myProfile,
                ),
                new Card(color: Colors.purpleAccent),
                new Card(
                  color: Colors.pink,
                ),
                new Card(
                  color: Colors.yellow,
                )
              ],
            )));
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  @override
  void initState() {
    print(FlutterYoutube
        .getIdFromUrl('https://www.youtube.com/watch?v=2MNZnklAjZw'));
    tabController = new TabController(length: 4, vsync: this);
    tabController.addListener(_onChanged);
    pgController = new PageController(
      initialPage: 0,
    );
    pgController.addListener(_onChanged);
    listener = () {
      final bool isPlaying = _cont.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    };
    _cont = VideoPlayerController.network(profile.user.profile_vid_url)
      ..addListener(listener)
      ..initialize().then((_) {
        setState(() {});
      });
    _cont.play();
    _cont.setLooping(true);
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));
  }

  Widget MyVidIntro() {
    return GestureDetector(
        /* onTap: () {
            if (tapped) {
              setState(() {
                tapped = true;
              });
              print("TAPPED***: $tapped");
              tapped = false;
            } else {
              setState(() {
                tapped = false;
              });
              print("TAPPED***: $tapped");
              tapped = true;
            }
          },*/
        onDoubleTap: () {
          if (_isMute) {
            setState(() {
              _cont.setVolume(0.0);
              _isMute = true;
            });
            _isMute = false;
          } else {
            setState(() {
              _cont.setVolume(1.0);
              _isMute = false;
            });
            _isMute = true;
          }
        },
        child: Stack(fit: StackFit.expand, children: <Widget>[
          _cont.value.initialized || _cont.value.isBuffering
              ? AspectRatio(
                  aspectRatio: _cont.value.aspectRatio,
                  child: VideoPlayPause(
                    _cont,
                    preview: true,
                  ))
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      Image(
                        image: AssetImage('images/ajax-loader.gif'),
                      ),
                      Text(
                        'Loading my Intro Vid..',
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Jua'),
                      )
                    ])),
          //tapped ? ButtonControlls():new Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    _isMute ? Icons.volume_up : Icons.volume_mute,
                    size: 40.0,
                    color: _isMute ? Colors.white30 : Colors.blue,
                  ),
                  onPressed: () {
                    if (_isMute) {
                      setState(() {
                        _cont.setVolume(0.0);
                        _isMute = true;
                      });
                      _isMute = false;
                    } else {
                      setState(() {
                        _cont.setVolume(1.0);
                        _isMute = false;
                      });
                      _isMute = true;
                    }
                  })
            ],
          )
        ]));
  }

  AnimationController animationController;

  Widget ButtonControlls() {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black54),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Center(
              child: IconButton(
            icon: AnimatedIcon(
                icon: _isPlaying
                    ? AnimatedIcons.pause_play
                    : AnimatedIcons.play_pause,
                color: Colors.white70,
                size: 70.0,
                progress: animationController),
            onPressed: () {
              if (_isPlaying) {
                setState(() {
                  _cont.pause();
                  _isPlaying = true;
                });
                _isPlaying = false;
              } else {
                setState(() {
                  tapped = true;
                  _cont.play();
                  _isPlaying = false;
                });
                _isPlaying = true;
              }
            },
          )),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    _cont.removeListener(listener);
    tabController.removeListener(() {});
    pgController.removeListener(() {});
    super.deactivate();
  }

  @override
  void dispose() {
    _cont.dispose();
    animationController.dispose();
    pgController.dispose();
    tabController.dispose();
  }
}

class VLogs extends StatefulWidget {
  final Profile profile;
  final Profile myProfile;
  final VideoPlayerController cont;
  final AnimationController animationController;
  final VoidCallback onPressed;

  VLogs(
      {this.profile,
      this.myProfile,
      this.animationController,
      this.onPressed,
      this.cont});

  VLogsState createState() =>
      new VLogsState(profile: profile, myProfile: myProfile);
}

class VLogsState extends State<VLogs> {
  final Profile profile;
  final Profile myProfile;
  bool tapped = false;
  bool _isPlaying = false;
  List<bool> playable = new List<bool>();
  VideoPlayerController _cont;
  final AnimationController animationController;
  final VoidCallback onPressed;
  String vidUrlToPLay;

  VLogsState(
      {this.profile, this.myProfile, this.animationController, this.onPressed});

  @override
  void deactivate() {
    _cont.removeListener(() {});

    super.deactivate();
  }

  @override
  void dispose() {
    _cont.dispose();
    animationController.dispose();
  }

  void initState() {
    for (int i = 0; i < profile.cinema.vlogs.length; i++) playable.add(false);
    print(FlutterYoutube
        .getIdFromUrl('https://www.youtube.com/watch?v=2MNZnklAjZw'));
    _cont = VideoPlayerController.network(vidUrlToPLay)
      ..addListener(() {
        final bool isPlaying = _cont.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        setState(() {});
      });
    _cont.pause();
    _cont.setLooping(false);
  }

  Widget createVLogs(Vids.Videos vids, int index) {
    return GestureDetector(
      onTap: () {
        launchFullScreen(context, vids);
      },
      onLongPress: () {
        setState(() {
          playable.clear();
          for (int i = 0; i < profile.cinema.vlogs.length; i++)
            playable.add(false);
          print('PLAYABLE AT lONG PRESS: ${playable}');
          playable[index] = true;
          print('PLAYABLE SET VID: ${playable}');
          _cont.dispose();
          _cont.removeListener(() {});
          vidUrlToPLay = vids.streamlink;
          _cont = VideoPlayerController.network(vidUrlToPLay)
            ..addListener(() {
              print("NOW AT: ${_cont.value.position.inSeconds}");
              if (_cont.value.position.inSeconds >=
                  (_cont.value.duration.inSeconds ~/ 2))
                setState(() {
                  _cont.removeListener(() {});
                  _cont.dispose();
                });

              _cont.seekTo(new Duration(seconds: (60)));
              final bool isPlaying = _cont.value.isPlaying;
              if (isPlaying != _isPlaying) {
                setState(() {
                  _isPlaying = isPlaying;
                  playable[index] = _isPlaying;
                  if (_isPlaying == false) {
                    playable.clear();
                    for (int i = 0; i < profile.cinema.vlogs.length; i++)
                      playable.add(false);
                    print('PLAYABLE SET VID: ${playable}');
                  }
                });
              }
            })
            ..initialize().then((_) {
              setState(() {});
            });
          _cont.play();
          _cont.seekTo(new Duration(seconds: (60)));

          _cont.setVolume(0.0);
          _cont.setLooping(false);
        });
      },
      onDoubleTap: () {
        FlutterYoutube.playYoutubeVideoByUrl(
            apiKey: "<API_KEY>", videoUrl: vids.youtubeLink);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 170.0,
            height: 105.0,
            color: Colors.grey[300],
            child: AspectRatio(
              aspectRatio: 16.0,
              child: Stack(fit: StackFit.expand, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: (_cont.value.initialized || _cont.value.isBuffering) &&
                          playable[index]
                      ? AspectRatio(
                          aspectRatio: _cont.value.aspectRatio,
                          child: VideoPlayer(_cont))
                      : FadeInImage.assetNetwork(
                          image: vids.thumbnail,
                          placeholder: 'images/blank.png',
                          fit: BoxFit.cover,
                        ),
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                end: Alignment.center,
                                begin: Alignment.bottomCenter,
                                colors: [Colors.black54, Colors.transparent])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                                child: IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ))
                          ],
                        ))
                  ],
                )
              ]),
            ),
          ),
          Container(
            width: 170.0,
            height: 20.0,
            color: Colors.grey[300],
            child: Text(
              vids.title,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
          ),
        ],
      ),
    );
  }

  Future launchFullScreen(BuildContext context, Vids.Videos v) async {
    //Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Video_Player(
            myProfile: myProfile,
            vid: v,
            profile: profile,
          );
        },
        fullscreenDialog: false));
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
        padding: const EdgeInsets.only(top: 5.0, left: 16.0),
        crossAxisCount: 2,
        children: new List.generate(profile.cinema.vlogs.length, (index) {
          return GridTile(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: createVLogs(profile.cinema.vlogs[index], index)),
            //Stack(fit: StackFit.expand,children: <Widget>[
            /*Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child:Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                      width: 100.0,
                      height: 50.0,
                      color: Colors.white
                  ),),),*/
            //],),
          );
        }));
    // TODO: implement build
  }

  Widget ButtonControlls() {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black54),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Center(
              child: IconButton(
            icon: AnimatedIcon(
                icon: _isPlaying
                    ? AnimatedIcons.pause_play
                    : AnimatedIcons.play_pause,
                color: Colors.white70,
                size: 70.0,
                progress: animationController),
            onPressed: onPressed,
          )),
        ],
      ),
    );
  }
}
