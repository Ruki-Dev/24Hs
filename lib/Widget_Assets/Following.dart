import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Widget_Assets/FollowersDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/FollowingDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/my_flutter_app_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Following extends StatelessWidget {
  final Profile profile;

  Following({this.profile});

  Future _openFollowingDialog(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new FollowingDialog(
            myProfile: profile,
          );
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: new IconButton(
          onPressed: () {
            _openFollowingDialog(context);
          },
          icon: new Icon(
            profile.follow.isFollow
                ? FontAwesomeIcons.solidHandsHelping
                : FontAwesomeIcons.handsHelping,
            size: 25.0,
          ),
        ),
      ),
      new Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: new Text('Following',
              style: new TextStyle(
                  fontFamily: 'ExoBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white))),
      new Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: new Text(new FormatValue(profile.follow.following).getValue(),
              style: new TextStyle(
                  fontFamily: 'ExoBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white))),
    ]);
  }
}

class FormatValue {
  final num _value;

  FormatValue(this._value);

  String getValue() {
    return new NumberFormat.compact().format(_value);
  }
}

class Followers extends StatelessWidget {
  final Profile profile;

  Followers({this.profile});

  Future _openFollowersDialog(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new FollowerDialog(
            myProfile: profile,
          );
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: new IconButton(
          onPressed: () {
            _openFollowersDialog(context);
          },
          icon: new Icon(
            profile.follow.isFollow
                ? FontAwesomeIcons.solidHandRock
                : FontAwesomeIcons.solidHandRock,
            size: 25.0,
          ),
        ),
      ),
      new Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: new Text(new FormatValue(profile.follow.followers).getValue(),
              style: new TextStyle(
                  fontFamily: 'ExoBold',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0))),
      new Text(
        "Followers",
        style: new TextStyle(
            fontSize: 16.0, fontFamily: "Jua", color: Colors.white),
      ),
    ]);
  }
}
