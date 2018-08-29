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
import 'package:twenty_four_hours/Gym/Awards/Awards.dart';
import 'package:twenty_four_hours/Gym/Models/Achievements.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Widget_Assets/AwardsDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/Following.dart';
import 'package:twenty_four_hours/Widget_Assets/ProfileImage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:convert/convert.dart';

class GoldDialog extends StatefulWidget {
  final Profile profile;

  GoldDialog({this.profile});

  @override
  GoldDialogState createState() => new GoldDialogState(profile: profile);
}

class GoldDialogState extends State<GoldDialog> {
  final Profile profile;

  GoldDialogState({this.profile});

  List<Award> awards = [];
  List<GoldAward> gA = [];
  List<GoldAward> total = new Awards().goldAwards();
  List<GoldAward> earned = [];
  Achievements achievements = new Achievements("gold", 1);

  Future initFile() async {
    String jsonAwards = await _loadAwardAssets();

    Map<String, dynamic> jSonFileContent = json.decode(jsonAwards);
    awards.add(new Award.fromJson(jSonFileContent));
    print("HERE: ${awards[0].goldAwards}");
    awards[0].goldAwards.forEach((element) {
      print("FOREACH: ${element}");
      gA.add(element as GoldAward);
    });
    achievements = new Achievements('gold', gA.length);
    print("GOLD: $gA");
    this.setState(() {
      Map<String, dynamic> jSonFileContent = json.decode(jsonAwards);
      awards.add(new Award.fromJson(jSonFileContent));
      awards[0].goldAwards.forEach((element) {
        GoldAward goldAward = element as GoldAward;
        gA.add(goldAward);
      });
      achievements = new Achievements('gold', gA.length);
    });
  }

  @override
  void initState() {
    this.initFile();
    initializeDateFormatting();
    print("GOLD: $gA");
    earned = profile.awards.goldAwards as List<GoldAward>;
    for (GoldAward gAward in total) {
      for (GoldAward g in earned) {
        if (g.id == gAward.id) {
          gAward.achieved = true;
        }
      }
    }
    achievements = new Achievements("gold", earned.length);
  }

  Future<String> _loadAwardAssets() async {
    return await rootBundle.loadString('GymJson/Awards.json');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: new Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 50.0,
                width: 80.0,
                padding: const EdgeInsets.only(top: 5.0),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                    boxShadow: [
                      const BoxShadow(),
                      const BoxShadow(),
                    ]),
                child: new Column(
                  children: <Widget>[
                    new Icon(
                      FontAwesomeIcons.trophy,
                      size: 22.0,
                      color: Colors.midnightTextPrimary,
                    ),
                    new Text(achievements.amount.toString(),
                        style: new TextStyle(fontFamily: 'Jua'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: AwardCard(total[index].title, total[index].description,
                total[index].dateTime,
                achieved: total[index].achieved),
            leading: new CircleAvatar(
              child: new Icon(
                  total[index].achieved ? FontAwesomeIcons.trophy : Icons.lock,
                  color: total[index].achieved
                      ? Colors.midnightTextPrimary
                      : Colors.white12),
              backgroundColor:
                  total[index].achieved ? Colors.blue : Colors.black26,
            ),
          );
        },
        itemCount: total.length,
        itemExtent: 152.0,
      ),
      backgroundColor: Colors.midnight_main,
    );
  }

  Widget AwardCard(String title, String desc, DateTime date,
      {bool achieved: false}) {
    return
        // Shimmer.fromColors(
        // baseColor: Colors.mainscreenDark,
        //  highlightColor: Colors.black26,
        // child:
        new Container(
      padding: const EdgeInsets.only(
          left: 22.0, right: 22.0, top: 12.0, bottom: 6.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            title,
            style: new TextStyle(
                color: achieved ? Colors.midnightTextPrimary : Colors.white70,
                fontFamily: 'Jua',
                fontSize: 18.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          new Text(
            desc,
            style: new TextStyle(
              color: achieved ? Colors.green : Colors.white24,
              fontSize: 14.0,
              fontFamily: 'Jua',
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(achieved ? 'Unlocked' : 'Locked',
                  style: new TextStyle(
                      color: achieved
                          ? Colors.midnightTextPrimary
                          : Colors.white24,
                      fontSize: 14.0,
                      fontFamily: 'Exo')),
              new Text(
                  achieved ? new DateFormat().add_yMMMd().format(date) : '--',
                  style: new TextStyle(
                      color: achieved
                          ? Colors.midnightTextPrimary
                          : Colors.white24,
                      fontSize: 12.0,
                      fontFamily: 'Exo')),
            ],
          )
        ],
      ),
      height: 110.0,
      margin: new EdgeInsets.only(left: 12.0),
      decoration: new BoxDecoration(
          color: Colors.mainscreenDark,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(12.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0))
          ]),
    );
  }
}
