import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:ui';

import 'package:twenty_four_hours/Authentication/LoginActivity.dart';
import 'package:twenty_four_hours/Authentication/RegisterForm.dart';
import 'package:twenty_four_hours/Widget_Assets/colors.dart';

//import 'package:image/image.dart' as imgs;
enum AppBarBehavior { normal, pinned, floating, snapping }

class RegisterMain extends StatefulWidget {
  RegisterMain({Key key, this.title}) : super(key: key);
  final String title;

  _RegisterActivity createState() => new _RegisterActivity();
}

class _RegisterActivity extends State<RegisterMain>
    with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _navTo(String route) {
    Navigator.of(context).pushNamed("/$route");
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    void _select(Choice choice) {
      // Causes the app to rebuild with the new _selectedChoice.
      setState(() {
        _selectedChoice = choice;
        print(choice.title);
        if (_selectedChoice.title == 'Register') {
          _navTo("Register");
        } else if (_selectedChoice.title == 'home') {
          _navTo('Home');
        } else if (_selectedChoice.title == 'Login') {
          _navTo('Login');
        }
      });
    }
  }

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.normal;
  final ThemeData _midnightTheme = _buildMidnightTheme();

  static ThemeData _buildMidnightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      accentColor: midnightAccent,
      primaryColor: midnightDark,
      buttonColor: midnight_button_Color,
      scaffoldBackgroundColor: midnight_main,
      cardColor: midnightDark,
      textSelectionColor: midnightTextPrimary,
      errorColor: Colors.red,
    );
  }

  Widget genrateBluredImage() {
    return new Container(
      width: 20.0,
      height: 20.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('images/ic_launcher.png'),
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

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: _midnightTheme,
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.midnight_main,
        body: new NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                expandedHeight: _appBarHeight,
                pinned: _appBarBehavior == AppBarBehavior.pinned,
                floating: _appBarBehavior == AppBarBehavior.floating ||
                    _appBarBehavior == AppBarBehavior.snapping,
                snap: _appBarBehavior == AppBarBehavior.snapping,
                actions: <Widget>[
                  new IconButton(
                    icon: Icon(choices[2].icon),
                    color: new Color.fromRGBO(255, 215, 0, 1.0),
                    onPressed: () {
                      _select(choices[2]);
                    },
                  ),
                  new PopupMenuButton<AppBarBehavior>(
                    onSelected: (AppBarBehavior value) {
                      setState(() {
                        _appBarBehavior = value;
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<AppBarBehavior>>[
                          PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.normal,
                            child: new Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  'Login as Guest',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Exo-Light',
                                      fontWeight: FontWeight.bold),
                                ),
                                new IconButton(
                                  icon: new Icon(
                                    choices[1].icon,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
                flexibleSpace: new FlexibleSpaceBar(
                  title: const Text(
                    'Welcome To 24 • Hours',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontFamily: 'Lobster',
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  background: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      genrateBluredImage(),
                      // This gradient ensures that the toolbar icons are distinct

                      // against the background image.

                      const DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: const LinearGradient(
                            begin: const Alignment(0.0, -1.0),
                            end: const Alignment(0.0, -0.4),
                            colors: const <Color>[
                              const Color(0x60000000),
                              const Color(0x00000000)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: new Container(
            color: Colors.mainscreenDark,
            padding: EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
            height: 1000.0,

            //child: new SingleChildScrollView(
            //padding: const EdgeInsets.only(top:150.0,left: 16.0,right: 16.0),
            child: new Container(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 16.0, right: 2.0),
                height: 1000.0,
                decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(15.0)),
                    color: Colors.midnight_main,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black12,
                          offset: new Offset(0.5, 1.0),
                          blurRadius: 5.0,
                          spreadRadius: 3.0),
                    ]),
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new RegisterForm(),
                    ],
                  ),
                )),
          ),

          /* new Column(
            children: <Widget>[
              new Container(
                height: 260.0,
                color: Colors.mainscreenDark,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(top:30.0,left: 20.0),
                      margin: new EdgeInsets.all(10.0),

                      child: new Row(
                        children: <Widget>[
                        new Expanded(
                         child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Register',
                            style: new TextStyle(
                              color: Colors.midnightAccent,
                              fontFamily: 'ExoLight',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),

                          ),
                          
                          new Text('Welcome To 24 Hours!',
                            style: new TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),

                      ),

                           new IconButton(
                            icon: new Icon(choices[2].icon),
                            color: new Color.fromRGBO(255, 215, 0, 1.0),
                            onPressed: () {
                              _select(choices[2]);
                            },
                          ),
                        ],
                    ),
                    ),
                 new Center(
                child: new Image.asset(
                  'images/ic_launcher.png',
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.scaleDown

                 ),
                 ),
                  ],
                ),
              ),
              new SingleChildScrollView(
              child:new RegisterForm(),
              ),
                ],

          ),*/
        ),
      ),
    );
  }
}
