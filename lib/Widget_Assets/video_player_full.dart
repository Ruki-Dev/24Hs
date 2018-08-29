import 'dart:async';
import 'dart:async';
import 'dart:ui' as deco;
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twenty_four_hours/Gym/Models/Cinema.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/Models/Videos.dart';
import 'package:twenty_four_hours/WidgetTests/VideoPlayer_FG.dart';
import 'package:twenty_four_hours/Widget_Assets/ChipTile.dart';
import 'package:twenty_four_hours/Widget_Assets/Video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/date_symbol_data_local.dart';

class Video_Player_full extends StatefulWidget {
  final Profile profile;
  final Profile myProfile;
  final Videos vid;
  final VideoPlayerController cont;

  Video_Player_full({this.profile, this.vid, this.cont, this.myProfile});

  FullVideoPlayerState createState() => FullVideoPlayerState(
      cont: cont, profile: profile, myProfile: myProfile, vid: vid);
}

class FullVideoPlayerState extends State<Video_Player_full>
    with TickerProviderStateMixin {
  final Profile profile;
  final Profile myProfile;
  final Videos vid;

  FullVideoPlayerState({this.profile, this.cont, this.vid, this.myProfile});

  final VideoPlayerController cont;
  VideoPlayerController controller;
  TextEditingController textEditingController = new TextEditingController();
  TabController tabController;
  PageController pgController;
  bool _isPlaying = false;
  bool _isMute = false;
  bool tapped = false;
  bool issmlPlaying = false;
  List<bool> playable = new List<bool>();
  ScrollController _scrollController = new ScrollController();

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
      body: MyVidIntro(),
      backgroundColor: Colors.black,
    );
  }

  Widget potraitMode(String img) {
    return new Stack(fit: StackFit.expand, children: <Widget>[
      new AspectRatio(
        aspectRatio: cont.value.aspectRatio,
        //I blured the parent conainer to blur background image, you can get rid of this part
        child: new BackdropFilter(
          filter: deco.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Container(
            //you can change opacity with color here(I used black) for background.
            decoration: new BoxDecoration(color: Colors.black.withOpacity(0.5)),
          ),
        ),
      ),
      new Center(
          child: new VideoPlayPause(
        cont,
        onDoubleTap: () {
          Navigator.pop(context);
        },
        videos: vid,
        fullPlayer: true,
      ))
    ]);
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  List<Videos> suggestedVids = new List<Videos>();

  Widget suggested() {
    print('SV: ${suggestedVids.length}');
    return ListView.builder(
      itemCount: suggestedVids.length,
      itemBuilder: (context, index) {
        print("dddd $index");
        return ListTile(
          trailing: Container(
            width: 100.0,
            height: 60.0,
          ),
        ); //Padding(padding: const EdgeInsets.all( 8.0),child: createVLogs(suggestedVids[index],index));
      },
    );
  }

  void initSuggested() {
    print("~Start");
    //TODO: Implements Scanning database for related tags
    print("~~Load${profile.cinema}");
    if (profile.cinema.vlogs != null)
      for (Videos v in profile.cinema.vlogs) {
        for (String tag in v.tags) {
          print("~~tags${tag}");
          if (vid.tags.contains(tag) && !suggestedVids.contains(v) && vid != v)
            suggestedVids.add(v);
        }
      }
    if (profile.cinema.workoutVids != null)
      for (Videos v in profile.cinema.workoutVids) {
        for (String tag in v.tags) {
          if (vid.tags.contains(tag) && !suggestedVids.contains(v) && vid != v)
            suggestedVids.add(v);
        }
      }
    if (profile.cinema.mealPreps != null)
      for (Videos v in profile.cinema.mealPreps) {
        for (String tag in v.tags) {
          if (vid.tags.contains(tag) && !suggestedVids.contains(v) && vid != v)
            suggestedVids.add(v);
        }
      }
  }

  Future launchFullScreen(BuildContext context, Videos v) async {
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

  String vidUrlToPLay = '';

  Widget createVLogs(Videos vids, int index) {
    print('????${controller}, ${vids}');
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
          controller.dispose();
          controller.removeListener(() {});
          vidUrlToPLay = vids.streamlink;
          controller = VideoPlayerController.network(vidUrlToPLay)
            ..addListener(() {
              print("NOW AT: ${controller.value.position.inSeconds}");
              if (controller.value.position.inSeconds >=
                  (controller.value.duration.inSeconds ~/ 2))
                setState(() {
                  controller.removeListener(() {});
                  controller.dispose();
                });

              // controller.seekTo(new Duration(seconds: (60)));
              final bool isPlaying = controller.value.isPlaying;
              if (isPlaying != issmlPlaying) {
                setState(() {
                  issmlPlaying = isPlaying;
                  playable[index] = issmlPlaying;
                  if (issmlPlaying == false) {
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
          //controller.play();
          // controller.seekTo(new Duration(seconds: (60)));

          controller.setLooping(false);
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
            height: 110.0,
            color: Colors.grey[300],
            child: AspectRatio(
              aspectRatio: 16.0,
              child: Stack(fit: StackFit.expand, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child:
                      /*(controller.value.initialized || controller.value.isBuffering)&&playable[index]
                        ? AspectRatio(
                        aspectRatio: controller.va                      placeholder: 'images/blank.png',
lue.aspectRatio, child: VideoPlayer(controller))
                        :*/
                      FadeInImage.assetNetwork(
                    placeholder: 'blank.png',
                    image: vids.thumbnail,
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
        ],
      ),
    );
  }

  String getVal(int val) {
    return new NumberFormat.compact().format(val);
  }

  final List<Widget> testCards = [
    new Card(
      color: Colors.red,
      child: Container(
        width: 50.0,
        height: 50.0,
      ),
    ),
    new Card(
        color: Colors.orange,
        child: Container(
          width: 50.0,
          height: 50.0,
        )),
    new Card(
      color: Colors.yellow,
      child: Container(
        width: 50.0,
        height: 50.0,
      ),
    ),
    new Card(
      color: Colors.blue,
      child: Container(
        width: 50.0,
        height: 50.0,
      ),
    ),
    new Card(
      color: Colors.green,
      child: Container(
        width: 50.0,
        height: 50.0,
      ),
    ),
    new Card(
      color: Colors.purpleAccent,
      child: Container(
        width: 50.0,
        height: 50.0,
      ),
    ),
    new Card(
      color: Colors.deepPurple,
      child: Container(
        width: 50.0,
        height: 50.0,
      ),
    )
  ];
  VoidCallback listener, smlListener;

  @override
  void initState() {
    initializeDateFormatting();
    listener = () {
      final bool isPlaying = cont.value.isPlaying;
      if (isPlaying) {
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
      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    };
    smlListener = () {
      final bool isPlaying = controller.value.isPlaying;
      if (isPlaying != issmlPlaying) {
        setState(() {
          issmlPlaying = isPlaying;
        });
      }
    };
    initSuggested();
    print("Suggested^^: ${suggestedVids}");
    for (int i = 0; i < profile.cinema.vlogs.length; i++) playable.add(false);
    print("$playable");
    print(FlutterYoutube
        .getIdFromUrl('https://www.youtube.com/watch?v=2MNZnklAjZw'));
    tabController = new TabController(length: 4, vsync: this);
    tabController.addListener(_onChanged);
    pgController = new PageController(
      initialPage: 0,
    );
    pgController.addListener(_onChanged);

    cont.play();
    cont.setLooping(false);
    controller = VideoPlayerController.network(vidUrlToPLay)
      ..addListener(smlListener)
      ..initialize().then((_) {
        setState(() {});
      });
    controller.pause();
    controller.setLooping(false);
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));
    var box = new Column(
      children: testCards,
    );
    data = <Entry>[
      Entry(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          /* */
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    DateFormat.yMMMd().format(vid.dateCreated),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              child: Icon(Icons.favorite),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(getVal(56500))),
                          ],
                        ),
                        IconButton(icon: Icon(Icons.share)),
                      ])
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  color: Colors.lightBlue,
                ),
                Text(getVal(75640)),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(vid.title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(profile.user.profile_pic_url),
                    ),
                    FlatButton(
                        child: Text(
                      profile.user.username,
                      style: TextStyle(color: Colors.lightBlue),
                    )),
                  ]),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(children: <Widget>[
                      FloatingActionButton(
                        mini: true,
                        child: Icon(
                          FontAwesomeIcons.solidHandPaper,
                          color: Colors.white,
                        ),
                        backgroundColor: _nameToColor(profile.user.username),
                      ),
                      FlatButton(
                          child: Text(
                        getVal(200000),
                        style: TextStyle(color: Colors.lightBlue),
                      )),
                    ]),
                  )
                ]),
          ),
          Divider(),
        ]),
        <Entry>[
          Entry(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 16.0),
                  child: Text(vid.decription, style: TextStyle(fontSize: 12.0)),
                ),
                /* Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Row(

          children:<Widget>[
            IconButton(icon: Icon(Icons.remove_red_eye),color: Colors.lightBlue,),
          Text(getVal(1000000000), style: TextStyle(color:Colors.lightBlue),),

          FloatingActionButton(child: Icon(Icons.favorite,color: Colors.white,),backgroundColor: Colors.red,),
            Text(getVal(1560000), style: TextStyle(color:Colors.lightBlue),),
            IconButton(icon: Icon(Icons.share),),
            FlatButton(child: Text('SHARE', style: TextStyle(color:Colors.lightBlue),)),

            IconButton(icon: Icon(Icons.add_to_queue),color: Colors.lightBlue,),



          ]),),*/
                new ChipTile(label: 'TAGS', children: suggestedChips()),
              ])),
        ],
      ),
      Entry(
        Text('You might like?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
        <Entry>[
          Entry(new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: customList(suggestedVids),
          ))
        ],
      ),
      Entry(
        Text('Comments',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
        <Entry>[
          Entry(
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(myProfile.user.profile_pic_url),
              ),
              Container(
                  width: 200.0,
                  child: FlatButton(child: Text('Express Your Opinion'))),
              /*  TextField(
            controller: textEditingController,
            style: TextStyle(

            ),
            decoration: InputDecoration(
              labelText: 'Express your Opinion'
            ),

          ),*/
            ]),
          ),
          Entry(
            Text('S'),
          ),
        ],
      ),
    ];
  }

  Widget MyVidIntro() {
    return GestureDetector(
        /*onTap: () {
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
        onLongPress: () {
          Navigator.pop(context);
        },
        child: Stack(fit: StackFit.expand, children: <Widget>[
          cont.value.initialized || cont.value.isBuffering
              ? MediaQuery.of(context).orientation == Orientation.portrait
                  ? AspectRatio(
                      aspectRatio: 3 / 2,
                      child: new VideoPlayPause(
                        cont,
                        videos: vid,
                        fullPlayer: true,
                      ))
                  : AspectRatio(
                      aspectRatio: cont.value.aspectRatio,
                      child: new VideoPlayPause(
                        cont,
                        videos: vid,
                        fullPlayer: true,
                        onDoubleTap: () {
                          Navigator.pop(context);
                        },
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
                        'Just a sec..',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jua',
                            fontSize: 12.0),
                      )
                    ])),
          // tapped ? ButtonControlls():new Container(),
          /*  Row(
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
                          cont.setVolume(0.0);
                          _isMute = true;
                        });
                        _isMute = false;
                      } else {
                        setState(() {
                          cont.setVolume(1.0);
                          _isMute = false;
                        });
                        _isMute = true;
                      }
                    })
              ],
            )*/
        ]));
  }

  AnimationController animationController;
  List<String> tags = new List<String>();
  final Set<String> _tools = new Set<String>();

  List<Widget> suggestedChips() {
    tags.addAll(vid.tags);
    if (tags != null && tags.isNotEmpty) {
      for (String tag in tags) _tools.add(tag);
    }
    final List<Widget> actionChips = _tools.map<Widget>((String tag) {
      return new ActionChip(
        backgroundColor: _nameToColor(tag),
        label: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text(tag,
                style: new TextStyle(
                    fontSize: 16.0, fontFamily: 'Jua', color: Colors.white))),
        onPressed: () {},
      );
    }).toList();
    return actionChips;
  }

  List<Widget> customList(List<Videos> vids) {
    int i = 0;
    List<Widget> children = List<Widget>();
    for (Videos v in vids) {
      children.add(new Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            createVLogs(v, i++),
            new Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                          width: 180.0,
                          child: new Text(v.title,
                              overflow: TextOverflow.ellipsis, maxLines: 3)),
                      Text(
                        v.uploader.user.username,
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.remove_red_eye,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                          Text(
                            getVal(75640),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                    ]))
          ])));
    }
    return children;
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
            onPressed: () {
              if (_isPlaying) {
                setState(() {
                  cont.pause();
                  _isPlaying = true;
                });
                _isPlaying = false;
              } else {
                setState(() {
                  tapped = true;
                  cont.play();
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
    controller.removeListener(() {});
    tabController.removeListener(() {});
    pgController.removeListener(() {});
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    pgController.dispose();
    tabController.dispose();
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final Widget title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
List<Entry> data;

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: root.title);
    return ExpansionTile(
      //  initiallyExpanded: true,

      key: PageStorageKey<Entry>(root),
      title: root.title,
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
