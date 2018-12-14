import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:intl/date_symbol_data_local.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter/material.dart';
import 'package:carousel/carousel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Gym/Awards/BronzeDialog.dart';
import 'package:twenty_four_hours/Gym/Awards/GoldDialog.dart';
import 'package:twenty_four_hours/Gym/Awards/SilverDialog.dart';
import 'package:twenty_four_hours/Gym/Contribute/Main.dart';
import 'package:twenty_four_hours/Gym/Models/Achievements.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/homePage.dart';
import 'package:twenty_four_hours/Gym/Workout/Main.dart';
import 'package:twenty_four_hours/Widget_Assets/AwardsDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/Following.dart';
import 'package:twenty_four_hours/Widget_Assets/FollowingDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/ProfileImage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:convert/convert.dart';
/*class MyFit extends StatefulWidget
{
  final String title;
  final Profile profile;
  MyFit({Key key,this.title,this.profile}): super(key: key);
  MyFitState createState()=>new MyFitState(profile: profile);
}*/

class MyfitWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final double currentWeight;
  final double weightGoal;
  final VoidCallback changeWeight;
  final Profile profile;

  MyfitWidget(
      {this.onPressed,
        this.profile,
        this.changeWeight,
        this.currentWeight: 120.0,
        this.weightGoal: 100.0});

  Widget testBGCarousel = new Container(
    child: new Carousel(
      children: [
        // new AssetImage('images/woman_work1.jpg'),
        new AssetImage('images/man_work.png'),
        new AssetImage('images/man_work1.png'),
        new AssetImage('images/woman_work2.jpg'),
      ]
          .map(
            (bgImg) => new Image(
            image: bgImg,
            fit: BoxFit.cover,
            color: Colors.black12,
            colorBlendMode: BlendMode.colorBurn),
      )
          .toList(),
      displayDuration: const Duration(seconds: 1),
    ),
  );

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  List<Widget> dashboard;

  @override
  Widget build(BuildContext context) {
    dashboard = [
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: () {
                _openProfile(context);
              },
              child: new Icon(Icons.add_box),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Feed",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: ()=>_openWorkout(context),
              child: new Icon(FontAwesomeIcons.dumbbell),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Workouts",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(Icons.library_books),
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepOrange),
          new Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: new Text(
              "Workout Plans",
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
            heroTag: null,
            onPressed: () {
              _openContribute(context);
            },
            child: new Icon(Icons.control_point_duplicate),
            foregroundColor: Colors.white70,
            backgroundColor: Colors.midnightTextPrimary,
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Contribute",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(Icons.photo_library),
              foregroundColor: Colors.white,
              backgroundColor: Colors.pinkAccent),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Gallery",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(Icons.video_library),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade800),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Cinema",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(Icons.filter_tilt_shift),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Goals",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(FontAwesomeIcons.utensils),
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Meal Plan",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(FontAwesomeIcons.chartLine),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Stats",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(FontAwesomeIcons.users),
              foregroundColor: Colors.white,
              backgroundColor: Colors.purple),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Group",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(Icons.lightbulb_outline),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black54),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Glossary",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new FloatingActionButton(
              heroTag: null,
              onPressed: null,
              child: new Icon(FontAwesomeIcons.quoteLeft),
              foregroundColor: Colors.black,
              backgroundColor: Colors.white),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Inspire Me!",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
        body: new CustomScrollView(slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: 256.0,
            pinned: true,
            floating: false,
            snap: false,
            actions: <Widget>[],
            flexibleSpace: new FlexibleSpaceBar(
                title: new Row(
                  children: <Widget>[],
                ),
                background: new Stack(fit: StackFit.expand, children: <Widget>[
                  /*   new PageView(
                  children: [testBGCarousel],
                ),*/
                  new Image(
                      image: AssetImage(_randomPic()),
                      fit: BoxFit.cover,
                      color: Colors.black12,
                      colorBlendMode: BlendMode.colorBurn),
                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: const <Color>[Colors.red, Colors.black12],
                      ),
                    ),
                  ),
                  _Header(
                    profile: profile,
                    context: context,
                    onPressed: onPressed,
                    profileImage: new ProfileImage(
                      profile.user.profile_pic_url.isEmpty,
                      true,
                      shape: BoxShape.circle,
                      fill: _nameToColor(profile.user.username),
                      color: _nameToColor(profile.user.username),
                      height: 70.0,
                      width: 70.0,
                      initials: profile.user.username.substring(0, 1).toUpperCase(),
                      image: new NetworkImage(profile.user.profile_pic_url),
                    ),
                    achievementCount: 123,
                    gold: new Achievements('gold', 12),
                    silver: new Achievements('silver', 300),
                    bronze: new Achievements('bronze', 1000),
                    weightGoal: weightGoal,
                    currentWeight: currentWeight,
                    following: new Following(profile: profile),
                    followers: new Followers(
                      profile: profile,
                    ),
                  ),
                ])),
          ),
          new SliverList(delegate: new SliverChildListDelegate(<Widget>[body()]))
        ]));
  }

  Future _openContribute(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new ContributeMain(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }
  Future _openWorkout(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new WorkoutMain(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }
  Future _openProfile(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Homepage(
            profile: profile,
            myProfile: profile,
          );
        },
        fullscreenDialog: true));
  }

  Widget body() {
    return new Container(
      height: 800.0,
      width: 400.0,
      padding: const EdgeInsets.all(30.0),
      color: Colors.mainscreenDark,
      child: new Card(
          color: Colors.midnight_main,
          child: new Padding(
              padding: const EdgeInsets.all(1.0),
              child: GridView.count(
                  crossAxisCount: 3,
                  children: new List.generate(dashboard.length, (index) {
                    return new Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: dashboard[index]);
                  })))),
    );
  }

  String _randomPic() {
    num n = rndNumber(0, 1);
    if (n >= 1)
      return 'images/woman_work1.jpg';
    else
      return 'images/man_work.png';
  }

  num rndNumber(num min, num max) {
    return new Random().nextInt(max - min + 1) + min;
  }

  Widget genrateBluredImage(String url) {
    return new Container(
      width: 20.0,
      height: 20.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage(url),
          fit: BoxFit.cover,
        ),
      ),
      //I blured the parent conainer to blur background image, you can get rid of this part
      child: new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: new Container(
          //you can change opacity with color here(I used black) for background.
          decoration: new BoxDecoration(color: Colors.black.withOpacity(0.5)),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ProfileImage profileImage;
  final int achievementCount;
  final double weightGoal;
  final double currentWeight;
  final Following following;
  final Followers followers;
  final Achievements gold;
  final Achievements silver;
  final Achievements bronze;
  final BuildContext context;
  final VoidCallback onPressed;
  List<Award> awards = [];
  final Profile profile;

  _Header(
      {this.profile,
        this.profileImage,
        this.onPressed,
        this.context,
        this.bronze,
        this.gold,
        this.silver,
        this.achievementCount,
        this.weightGoal = 122.0,
        this.currentWeight = 120.0,
        this.following,
        this.followers});

  Future initFile() async {
    String jsonAwards = await _loadAwardAssets();
    print(jsonAwards);
    Map<String, dynamic> jSonFileContent = json.decode(jsonAwards);
    awards.add(new Award.fromJson(jSonFileContent));
    print(awards[0].bronzeAwards);
    goldAwards = (awards[0].goldAwards);
    bronzeAwards = (awards[0].bronzeAwards);
    silverAwards = (awards[0].silverAwards);
  }

  Future<String> _loadAwardAssets() async {
    return await rootBundle.loadString('GymJson/Awards.json');
  }

  @override
  Widget build(BuildContext context) {
    //initFile();

    return new Container(
        padding: const EdgeInsets.all(12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    profileImage,
                    new Row(
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new IconButton(
                                onPressed: _openGoldDialog,
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color: Colors.midnightTextPrimary,
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getValue(profile.awards.totalGold.amount),
                                style: new TextStyle(
                                    color: Colors.midnightTextPrimary,
                                    fontFamily: 'Jua'),
                              ),
                            ),
                          ],
                        ),
                        new Column(
                          children: <Widget>[
                            new IconButton(
                                onPressed: _openSilverDialog,
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color:
                                    new Color.fromRGBO(191, 191, 191, 1.0),
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getValue(profile.awards.totalSilver.amount),
                                style: new TextStyle(
                                    color:
                                    new Color.fromRGBO(191, 191, 191, 1.0),
                                    fontFamily: 'Jua'),
                              ),
                            ),
                          ],
                        ),
                        new Column(
                          children: <Widget>[
                            new IconButton(
                                onPressed: _openBronzeDialog,
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color:
                                    new Color.fromRGBO(191, 128, 64, 1.0),
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getValue(profile.awards.totalBronze.amount),
                                style: new TextStyle(
                                    color:
                                    new Color.fromRGBO(191, 128, 64, 1.0),
                                    fontFamily: 'Jua'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                new GestureDetector(
                  onTap: onPressed,
                  child: new Hexagon(
                    offset: new Offset(20.0, 0.0),
                    elevation: 22.0,
                    onPressed: onPressed,
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.mainscreenDark,
                          Colors.black54,
                        ],
                      ),
                    ),
                    child: new Transform.translate(
                      offset: const Offset(15.0, 0.0),
                      child: new Container(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Kg",
                              style: new TextStyle(
                                  color: Colors.green,
                                  fontSize: 16.0,
                                  fontFamily: 'Jua'),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: new Text(
                                  new NumberFormat('###.##')
                                      .format(currentWeight),
                                  style: new TextStyle(
                                      color: currentWeight <= weightGoal
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 26.0,
                                      fontFamily: 'Audiowide')),
                            ),
                            new Text(
                              new NumberFormat('###.##').format(weightGoal),
                              style: new TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14.0,
                                  fontFamily: 'Audiowide'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            new Padding(padding: const EdgeInsets.all(20.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[following, followers],
            )
          ],
        ));
  }

  String getValue(int val) {
    return new NumberFormat.compact().format(val);
  }

  var goldAwards = [];
  var silverAwards = [];
  var bronzeAwards = [];


  Future _openGoldDialog() async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new GoldDialog(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }

  Future _openSilverDialog() async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new SilverDialog(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }

  Future _openBronzeDialog() async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new BronzeDialog(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }
}

class Hexagon extends StatelessWidget {
  final Widget child;
  final Size size;
  final Color shadowColor;
  final double borderRadius;
  final double elevation;
  final int side;
  final Decoration decoration;
  final Offset offset;
  final VoidCallback onPressed;

  Hexagon(
      {this.child,
        this.onPressed,
        this.offset: const Offset(10.0, 20.0),
        this.size: const Size(120.0, 120.0),
        this.shadowColor: Colors.black45,
        this.borderRadius: 5.0,
        this.elevation = 10.0,
        this.side = 6,
        this.decoration});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height, maxWidth: size.width),
      child: new Stack(
        fit: StackFit.loose,
        children: <Widget>[
          new ClipPolygon(
            size: size,
            child: new Container(
              decoration: decoration,
            ),
            boxShadows: [
              new PolygonBoxShadow(color: shadowColor, elevation: elevation),
            ],
            sides: side,
            borderRadius: borderRadius,
          ),
          new Transform.translate(child: child, offset: offset),
          new Transform.translate(
              child: new FloatingActionButton(
                  onPressed: onPressed,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent),
              offset: new Offset(28.0, 23.0)),
        ],
      ),
    );
  }
}
