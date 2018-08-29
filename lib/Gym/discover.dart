import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel/carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Gym/Models/Achievements.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Widget_Assets/Following.dart';
import 'package:twenty_four_hours/Widget_Assets/ProfileImage.dart';

class Discover extends StatefulWidget {
  final String title;

  Discover({Key key, this.title}) : super(key: key);

  DiscoverState createState() => new DiscoverState();
}

class DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}

class DiscoverWidget extends StatelessWidget {
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

  final Profile profile;

  DiscoverWidget({this.profile});

  @override
  Widget build(BuildContext context) {
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
                    colors: const <Color>[Colors.deepPurple, Colors.black12],
                  ),
                ),
              ),
              _Header(
                profileImage: new ProfileImage(
                  true,
                  true,
                  shape: BoxShape.circle,
                  image: new AssetImage("images/fat_man"),
                ),
                achievementCount: 123,
                gold: new Achievements('gold', 12),
                silver: new Achievements('silver', 300),
                bronze: new Achievements('bronze', 1000),
                weightGoal: 120.0,
                currentWeight: 144.0,
                following: new Following(
                  profile: profile,
                ),
                followers: new Followers(
                  profile: profile,
                ),
              ),
            ])),
      ),
      new SliverList(delegate: new SliverChildListDelegate(<Widget>[]))
    ]));
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

  _Header(
      {this.profileImage,
      this.bronze,
      this.gold,
      this.silver,
      this.achievementCount,
      this.weightGoal,
      this.currentWeight,
      this.following,
      this.followers});

  @override
  Widget build(BuildContext context) {
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
                                onPressed: _showAchivements(gold.id),
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color: Colors.midnightTextPrimary,
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getValue(gold.amount),
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
                                onPressed: _showAchivements(silver.id),
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color:
                                        new Color.fromRGBO(191, 191, 191, 1.0),
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getValue(silver.amount),
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
                                onPressed: _showAchivements(bronze.id),
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color:
                                        new Color.fromRGBO(191, 128, 64, 1.0),
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getValue(bronze.amount),
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
                new Hexagon(
                  offset: new Offset(20.0, 0.0),
                  elevation: 22.0,
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
                          child: new Text(currentWeight.toString(),
                              style: new TextStyle(
                                  color: currentWeight <= weightGoal
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 26.0,
                                  fontFamily: 'Audiowide')),
                        ),
                        new Text(
                          weightGoal.toString(),
                          style: new TextStyle(
                              color: Colors.blue,
                              fontSize: 14.0,
                              fontFamily: 'Audiowide'),
                        ),
                      ],
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

  _showAchivements(String type) {}
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

  Hexagon(
      {this.child,
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
        ],
      ),
    );
  }
}
