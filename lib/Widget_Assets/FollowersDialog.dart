import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Widget_Assets/Following.dart';
import 'package:twenty_four_hours/Widget_Assets/ProfileImage.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/homePage.dart';

class FollowerDialog extends StatefulWidget {
  final String title;
  final Profile myProfile;

  FollowerDialog({Key key, this.title, this.myProfile}) : super(key: key);

  FollowerState createState() => new FollowerState(myProfile: myProfile);
}

class FollowerState extends State<FollowerDialog> {
  Follows follows, follows2;
  List<Register> users = [];
  Profile myProfile;

  FollowerState({this.myProfile});

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: new Followers(profile: myProfile)),
      body: new GridView.count(
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 3,
        children:
            new List.generate(myProfile.follow.myFollowers.length, (index) {
          return new Padding(
              padding: const EdgeInsets.all(12.0),
              child: Bubbles(
                myProfile: myProfile,
                userinformation: myProfile.follow.myFollowers[index],
                followers: myProfile.follow.myFollowers[index].follow.followers,
              ));
        }),
      ),
    );
  }

  @override
  void dispose() {}
}

class Bubbles extends StatelessWidget {
  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  final Profile userinformation;
  final Profile myProfile;
  final Register follows;
  final num followers;

  Bubbles(
      {this.userinformation, this.myProfile, this.follows, this.followers: 0});

  String getValue(num val) {
    return new NumberFormat.compact().format(val);
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      overflow: Overflow.clip,
      children: <Widget>[
        new CircleAvatar(
          foregroundColor: Colors.black26,
          backgroundColor: Colors.black12,
          backgroundImage: userinformation.user.profile_pic_url.isNotEmpty
              ? new NetworkImage(userinformation.user.profile_pic_url)
              : new AssetImage('blank.png'),
        ),
        /*new ProfileImage(
          userinformation.profile_pic_url.isEmpty,
          true,
          shape: BoxShape.circle,
          height: 70.0,
          width: 70.0,
          image: userinformation.profile_pic_url.isNotEmpty ? new NetworkImage(userinformation.profile_pic_url):new AssetImage('blank.png'),
          color: _nameToColor(userinformation.username),
          fill: _nameToColor(userinformation.username),
        ),*/
        new GestureDetector(
          onTap: () => _openProfile(context),
          child: new Container(
            height: 100.0,
            width: 100.0,
            decoration: new BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    userinformation.user.username,
                    style:
                        new TextStyle(fontFamily: 'Jua', color: Colors.white),
                  ),
                  // followersStack()
                  new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Center(
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            new Text(
                              getValue(followers),
                              style: new TextStyle(
                                  fontFamily: 'Jua', color: Colors.white),
                            ),
                            new Icon(
                              FontAwesomeIcons.solidHandRock,
                              color: Colors.white,
                              size: 9.0,
                            ),
                          ])))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future _openProfile(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Homepage(
            profile: userinformation,
            myProfile: myProfile,
          );
        },
        fullscreenDialog: true));
  }

  Widget followersStack() {
    return new Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        overflow: Overflow.clip,
        children: <Widget>[
          new Container(
            height: 100.0,
            width: 100.0,
            color: Colors.transparent,
          ),
          new Icon(
            FontAwesomeIcons.solidHandRock,
            color: Colors.white,
            size: 15.0,
          ),
          new Text(
            getValue(followers),
            style: new TextStyle(fontFamily: 'Jua', color: Colors.black12),
          ),
          // new Icon(FontAwesomeIcons.solidHandRock,color: Colors.white,size: 20.0,),
        ]);
  }
}
