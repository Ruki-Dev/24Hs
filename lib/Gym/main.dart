import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:convert/convert.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:carousel/carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Gym/24H.dart';
import 'package:twenty_four_hours/Gym/Models/Achievements.dart';
import 'package:twenty_four_hours/Gym/Models/Award.dart';
import 'package:twenty_four_hours/Gym/Models/CreateAccounts.dart';
import 'package:twenty_four_hours/Gym/Models/Follows.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/MyFit.dart';
import 'package:twenty_four_hours/Gym/discover.dart';
import 'package:twenty_four_hours/Widget_Assets/Following.dart';
import 'package:twenty_four_hours/Widget_Assets/ProfileImage.dart';

class GymMain extends StatefulWidget {
  final String title;

  GymMain({Key key, this.title}) : super(key: key);

  GymState createState() => new GymState();
}

class GymState extends State<GymMain> with TickerProviderStateMixin {
  Profile profile;
  Follows follows, follows2, follows3;
  final TextEditingController controller = new TextEditingController();
  final TextEditingController acontroller = new TextEditingController();
  Color pageColor = Colors.red;
  TabController tabController;

  GymState({this.profile});

  @override
  initState() {
    super.initState();

    profile = new CreateAccounts().ollie();
    tabController = new TabController(length: 3, vsync: this);
    tabController.addListener(_onChanged);
  }

  Future<Null> _showAlertDialog(context) async {
    controller.text = new NumberFormat("###.##").format(weightGoal);
    acontroller.text = new NumberFormat("###.##").format(currentWeight);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: new Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.mainscreenDark,
                  child: new Hexagon(
                    offset: new Offset(0.0, 0.0),
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
                    child: new Center(
                        child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new Container(
                          width: 90.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            color: Colors.midnightTextSecnodary,
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          child: new TextField(
                            keyboardType: TextInputType.number,
                            controller: acontroller,
                            style: new TextStyle(
                              fontFamily: 'Audiowide',
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              suffixIcon: new Text('Kg'),
                              labelText: 'Goal',
                              labelStyle: new TextStyle(
                                  fontFamily: 'Audiowide', color: Colors.white),
                              border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(
                                      width: 0.0, color: Colors.white)),
                            ),
                          ),
                        ),
                        new TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: controller,
                            style: new TextStyle(
                              fontFamily: 'Audiowide',
                              color: Colors.white,
                            ),
                            decoration: new InputDecoration(
                              fillColor: Colors.midnight_main,
                              filled: true,
                              suffixIcon: new Text("Kg",
                                  style: new TextStyle(
                                      color: Colors.midnightTextPrimary,
                                      fontFamily: 'Audiowide')),
                              labelStyle: new TextStyle(
                                color: Colors.white,
                              ),
                              border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: new BorderSide(
                                      width: 0.0, color: Colors.white)),
                              labelText: " Current Weight ",
                            )),
                        new FloatingActionButton(
                          onPressed: () {
                            print(currentWeight);
                            setState(() {
                              weightGoal = controller.text.isNotEmpty
                                  ? double.tryParse(acontroller.text)
                                  : weightGoal = 120.2;
                              currentWeight = acontroller.text.isNotEmpty
                                  ? double.tryParse(controller.text)
                                  : currentWeight = 120.0;
                            });
                            Navigator.pop(context);
                          },
                          child: new Icon(Icons.check),
                          backgroundColor: Colors.green,
                        )
                      ],
                    )),
                    side: 6,
                    size: new Size(250.0, 250.0),
                  )));
        });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    controller.dispose();
    acontroller.dispose();
  }

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
  VoidCallback onPressed;
  double currentWeight = 111.0;
  double weightGoal = 120.0;
  VoidCallback changeWeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new TabBarView(
          children: <Widget>[
            new MyfitWidget(
              profile: profile,
              weightGoal: weightGoal,
              currentWeight: currentWeight,
              onPressed: () {
                _showAlertDialog(context);
              },
              changeWeight: () {
                setState(() {
                  weightGoal = double.tryParse(controller.text);
                  print(weightGoal);
                  currentWeight = double.tryParse(acontroller.text);
                });
              },
            ),
            new DiscoverWidget(
              profile: profile,
            ),
            new TwentyFourHWidget(
              profile: profile,
            )

            //new page("hey bottomNavigation"),new page('the other one!'),new page('headset is on?')
          ],
          controller: tabController,
        ),
        bottomNavigationBar: new Material(
          color: pageColor,
          child: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                  child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.accessibility),
                  new Text(
                    " • MyFit",
                    style: new TextStyle(color: Colors.white),
                  )
                ],
              )),
              new Tab(
                  child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.blur_on),
                  new Text(
                    " • Discover",
                    style: new TextStyle(color: Colors.white),
                  )
                ],
              )),
              new Tab(
                  child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.blur_circular),
                  new Text(
                    " • 24H",
                    style: new TextStyle(color: Colors.white),
                  )
                ],
              )),
            ],
          ),
        ));
  }

  void _onChanged() {
    setState(() {
      print(tabController.index);
      if (tabController.index == 0) {
        pageColor = Colors.red;
      } else if (tabController.index == 1) {
        pageColor = Colors.deepPurple;
      } else {
        pageColor = Colors.green;
      }
    });
  }

  void _changeWeight() {
    print(weightGoal);
    setState(() {
      weightGoal = double.tryParse(controller.text);
      print(weightGoal);
      currentWeight = double.tryParse(acontroller.text);
    });
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
