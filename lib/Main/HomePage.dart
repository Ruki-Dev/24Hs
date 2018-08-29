import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Authentication/auth.dart';
import 'package:twenty_four_hours/Authentication/auth_provider.dart';
import 'dart:async';
import 'package:twenty_four_hours/Main/NavigationDrawer.dart';
import 'package:twenty_four_hours/Main/rain.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four_hours/Weather/Forcast/generic_widgets/sliding_drawer.dart';
import 'package:twenty_four_hours/Weather/Forcast/radial_list.dart';
import 'package:twenty_four_hours/Weather/ForecastData.dart';
import 'dart:convert';

import 'package:twenty_four_hours/Weather/WeatherData.dart';
import 'package:twenty_four_hours/Widget_Assets/RoundProgressIndicator.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.onSignedOut}) : super(key: key);
  final String title;
  final VoidCallback onSignedOut;

  void _signOut(BuildContext context) async {
    try {
      var auth = AuthProvider.of(context).auth;

      await auth.signOut();

      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePage createState() => new _HomePage();
}

FirebaseUser user;

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  /** VARIABLES **/
  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;
  Location _location = new Location();
  String error;
  var _scrollController = new ScrollController();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.normal;
  String coverUrl = '';
  var stops = [0.3, 0.6, 0.9];
  Color deepShade = new Color.fromRGBO(153, 230, 255, 1.0),
      mediumShade = new Color.fromRGBO(204, 242, 255, 1.0),
      shallowShade = new Color.fromRGBO(255, 255, 255, 1.0);
  bool isMorning = true;
  String currentTime = new DateFormat.Hm().format(new DateTime.now()),
      currentDate = new DateFormat.yMMMEd().format(new DateTime.now());
  String dayLeft;
  bool isRunning;
  bool _hasFlash = false;
  bool _isOn = false;
  double _intensity = 1.0;
  String currentUser = '';
  String greetingMsg = '...';
  bool rain = false;
  String bgImg = 'images/blank.png';
  String weatherImg = 'images/blank.png';
  Timer _timer;
  DateTime dateTime;
  TabController _tabController;
  List<HomeDisplay> choices;
  OpenableController openableController;
  SlidingRadialListController slidingListController;
  RadialListViewModel items =
      new RadialListViewModel(items: [new RadialListItemViewModel()]);

  Future updateTime() async {
    DateTime date = await DateTime.now();
    // print(date);
    setState(() {
      currentTime = new DateFormat.Hms().format(date);
    });
  }

  Future _currentUser() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user == null)
      setState(() {
        currentUser = 'Guest';
      });
    else
      setState(() {
        currentUser = user.displayName;
      });
  }

  @override
  Widget build(BuildContext context) {
    //  choices=[new HomeDisplay(title:'home',radialList:items,slidingListController:slidingListController,stops:stops,deepShade: deepShade,mediumShade: mediumShade,shallowShade: shallowShade,),new HomeDisplay(error:error,isLoading:isLoading,loadWeather:loadWeather,location: _location,forecastData:forecastData,weatherData: weatherData,title: 'weather')];

    return MaterialApp(
      home: Scaffold(
        persistentFooterButtons: <Widget>[
          FloatingActionButton(
            heroTag: 'j',
            child: Icon(FontAwesomeIcons.dumbbell),
            onPressed: () {
              Navigator.of(context).pushNamed("/Gym");
            },
          ),
          FloatingActionButton.extended(
            heroTag: 'pt',
            icon: Icon(FontAwesomeIcons.signOutAlt),
            label: Text('LOGOUT',
                style: TextStyle(color: Colors.white70, fontFamily: 'EXO')),
            backgroundColor: Colors.red,
            onPressed: () {
              Auth().signOut(context);
            },
          )
        ],
        backgroundColor: Colors.midnight,
        drawer: NavigationDrawer(
          coverUrl.isEmpty,
          coverurl: coverUrl,
          color: deepShade,
        ),
        body: new NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: deepShade,
                expandedHeight: _appBarHeight,
                pinned: _appBarBehavior == AppBarBehavior.pinned,
                floating: _appBarBehavior == AppBarBehavior.floating ||
                    _appBarBehavior == AppBarBehavior.snapping,
                snap: _appBarBehavior == AppBarBehavior.snapping,
                actions: <Widget>[
                  new IconButton(
                    icon: Icon(Icons.chat_bubble_outline,
                        color: Colors.midnightTextPrimary),
                    onPressed: () {},
                  ),
                  new IconButton(
                    icon:
                        Icon(Icons.settings, color: Colors.midnightTextPrimary),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: new FlexibleSpaceBar(
                  title: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[],
                  ),
                  background: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      // This gradient ensures that the toolbar icons are distinct

                      // against the background image.

                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: stops,
                            colors: <Color>[
                              deepShade,
                              mediumShade,
                              shallowShade
                            ],
                          ),
                        ),
                      ),

                      new Transform.translate(
                        offset: new Offset(0.0, 100.0),
                        child: new Image(
                          image: new AssetImage(bgImg),
                          fit: BoxFit.scaleDown,
                          height: 70.0,
                          width: 90.0,
                        ),
                      ),
                      new Transform.translate(
                        offset: new Offset(0.0, 10.0),
                        child: new Image(
                          image: new AssetImage(weatherImg),
                          fit: BoxFit.scaleDown,
                          height: 70.0,
                          width: 90.0,
                        ),
                      ),
                      TabBarView(
                        controller: _tabController,
                        children: choices.map((HomeDisplay choice) {
                          return Padding(
                            padding: EdgeInsets.zero,
                            child: ChoiceCard(
                              tabController: _tabController,
                              currentTime: currentTime,
                              currentDate: currentDate,
                              choice: choice,
                              isMorning: isMorning,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: ListTile(),
        ),
      ),
    );
  }

  FirebaseUser user;
  FirebaseAuth Fauth;
  Register userInfo = new Register();
  String UID = '';
  DatabaseReference reference;

  currentUserInfo() {
    reference = FirebaseDatabase.instance.reference();

    Auth().currentUser().then((uid) {
      reference
          .child("User_Information")
          .child(uid)
          .onChildAdded
          .listen(_onEntryAdded);
      setState(() {
        userInfo = userInfo;
      });
    });
  }

  _onEntryAdded(Event event) {
    userInfo = (new Register.fromSnapshot(event.snapshot));
    //   print(userInfo);
  }

  String dayProgress;
  double startAt;
  String hbotMsg = '...', hbotImg = 'images/hbot.png';

  void setTime(Timer timer) {
    currentUserInfo();
    final greetings = [
      "Good Morning ${userInfo.username}",
      "Good Afternoon",
      "It\'s Going to be a beautiful day today",
      "Good Evening",
      "Night Night! "
    ];
    setState(() {
      currentUserInfo();
      hbotMsg = 'Hey ${userInfo.username}';
      hbotImg = 'images/hbot.png';
      dayProgress = '${100 - ((dateTime.hour * 100) / 24).round()}%';
      startAt = ((dateTime.hour * 100) / 24) / 100;
      //    print('hour: ${dateTime.hour} __ $dayProgress');
      dateTime = new DateTime.now();
      currentTime = new DateFormat.Hm().format(dateTime);
      currentDate = new DateFormat.yMMMEd().format(dateTime);
      // print("DateTime: ${dateTime.hour}");
      if (dateTime.hour >= 1 && dateTime.hour <= 3) {
        bgImg = 'images/mnight.png';
        hbotImg = 'assets/gifs/hbot_sleep.gif';
        deepShade = new Color.fromRGBO(80, 0, 179, 1.0);
        mediumShade = new Color.fromRGBO(133, 51, 255, 1.0);
        shallowShade = new Color.fromRGBO(198, 26, 255, 1.0);
        //stops=[0.4,0.6,1.0];
        greetingMsg = greetings[4];
        isMorning = false;
      } else if (dateTime.hour >= 4 && dateTime.hour <= 6) {
        greetingMsg = greetings[4];
        bgImg = 'images/mnight.png';
        hbotImg = 'assets/gifs/hbot_sleep.gif';
        deepShade = new Color.fromRGBO(0, 0, 102, 1.0);
        mediumShade = new Color.fromRGBO(0, 51, 153, 1.0);
        shallowShade = new Color.fromRGBO(51, 102, 153, 1.0);
        //stops=[0.4,0.6,1.0];
        isMorning = false;
      } else if (dateTime.hour >= 7 && dateTime.hour <= 11) {
        greetingMsg = greetings[0];
        bgImg = 'images/grass-outline-hi.png';
        deepShade = new Color.fromRGBO(0, 204, 255, 1.0);
        mediumShade = new Color.fromRGBO(102, 255, 204, 1.0);
        shallowShade = new Color.fromRGBO(255, 255, 204, 1.0);
        //stops=[0.4,0.6,1.0];
        isMorning = true;
      } else if (dateTime.hour >= 12 && dateTime.hour <= 17) {
        greetingMsg = greetings[rndNumber(1, 2)];
        bgImg = 'images/sea.png';
        deepShade = new Color.fromRGBO(153, 230, 255, 1.0);
        mediumShade = new Color.fromRGBO(204, 242, 255, 1.0);
        shallowShade = new Color.fromRGBO(255, 255, 204, 1.0);
        //stops=[0.4,0.6,1.0];
        isMorning = true;
      } else if (dateTime.hour >= 18 && dateTime.hour <= 19) {
        greetingMsg = greetings[3];
        bgImg = 'images/sea.png';
        shallowShade = new Color.fromRGBO(255, 102, 0, 1.0);
        mediumShade = new Color.fromRGBO(255, 153, 153, 1.0);
        deepShade = new Color.fromRGBO(255, 204, 153, 1.0);
        //stops=[0.4,0.6,1.0];
        isMorning = true;
      } else {
        greetingMsg = greetings[4];
        bgImg = 'images/night.png';
        deepShade = new Color.fromRGBO(204, 0, 204, 1.0);
        mediumShade = new Color.fromRGBO(255, 102, 153, 1.0);
        shallowShade = new Color.fromRGBO(255, 166, 77, 1.0);
        //stops=[0.4,0.6,1.0];
        isMorning = true;
      }
    });
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  num rndNumber(num min, num max) {
    return new Random().nextInt(max - min + 1) + min;
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.dispose();
    openableController.dispose();
    slidingListController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadWeather();
    _currentUser();
    //hbotMsg='Hey ${Auth().currentUserInfo()==null? 'Hey,Welcome back!':Auth().currentUserInfo().username},)}';
    hbotImg = 'images/hbot.png';
    super.initState();
    dateTime = new DateTime.now();
    slidingListController = new SlidingRadialListController(
      itemCount: items.items.length,
      vsync: this,
    )..open();
    openableController = new OpenableController(
      vsync: this,
      openDuration: const Duration(milliseconds: 250),
    )..addListener(() => setState(() {}));

    choices = [
      new HomeDisplay(
        title: 'home',
        startAt: startAt,
        user: currentUser,
        hbotImg: hbotImg,
        dayProgress: dayProgress,
        rain: rain,
        slidingListController: slidingListController,
        hbotMsg: greetingMsg,
        radialList: items,
        deepShade: deepShade,
        mediumShade: mediumShade,
        shallowShade: shallowShade,
      ),
      new HomeDisplay(
          error: error,
          startAt: startAt,
          hbotMsg: greetingMsg,
          hbotImg: hbotImg,
          dayProgress: dayProgress,
          bgImg: bgImg,
          greeting: greetingMsg,
          isLoading: isLoading,
          loadWeather: loadWeather,
          user: currentUser,
          location: _location,
          forecastData: forecastData,
          weatherData: weatherData,
          title: 'weather')
    ];

    _tabController = TabController(vsync: this, length: choices.length);
    _timer = new Timer.periodic(const Duration(seconds: 1), setTime);
    initializeDateFormatting();

    // updateTime();
  }

  loadWeather() async {
    // print("Weather: ${weatherData}");
    setState(() {
      isLoading = true;
    });

    Map<String, double> location;

    try {
      location = await _location.getLocation;

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }
    //  print("Location: $location");

    if (location != null) {
      final lat = location['latitude'];
      final lon = location['longitude'];
      //    print("Lon: $lon\nLat: $lat");

      final weatherResponse = await http.get(
          Uri.encodeFull(
              'https://api.openweathermap.org/data/2.5/weather?APPID=25ec50668027be7e6c540df0784d29b4&lat=${lat}&lon=${lon}'),
          headers: {"Accept": "application/json"});
      //  print("Weather Response: ${weatherResponse.body}");
      final forecastResponse = await http.get(
          Uri.encodeFull(
              'https://api.openweathermap.org/data/2.5/forecast?APPID=25ec50668027be7e6c540df0784d29b4&lat=${lat}&lon=${lon}'),
          headers: {"Accept": "application/json"});
      //  print("Weather Response: ${forecastResponse.body}");
      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        return setState(() {
          weatherData =
              new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          //         print("Weather DataM: $weatherData");
          forecastData =
              new ForecastData.fromJson(jsonDecode(forecastResponse.body));
          isLoading = false;

          if (WeatherData != null) {
            //             print("Weather Type: ${weatherData.main}");
            if (weatherData.desc.toLowerCase().contains('broken clouds')) {
              weatherImg = 'images/rainclouds.png';
            } else if (weatherData.main.toLowerCase().contains('clear')) {
              weatherImg = 'images/sun_hot.png';
            } else if (weatherData.main.toLowerCase() == 'clouds') {
              weatherImg = 'images/cloudy.png';
            } else if (weatherData.main.toLowerCase() == 'shower') {
              weatherImg = 'images/rainClouds.png';
            } else if (weatherData.main.toLowerCase() == 'rain') {
              weatherImg = 'images/cloudypng';
              setState(() {
                rain = true;
              });
            } else if (weatherData.main.toLowerCase() == 'thunderstorm') {
              weatherImg = 'images/rainClouds.png';
            } else if (weatherData.main.toLowerCase() == 'snow') {
              weatherImg = 'images/rainClouds.png';
            } else if (weatherData.main.toLowerCase() == 'mist') {
              weatherImg = 'images/wind.png';
            }
          }
          if (forecastData != null) {
            List<RadialListItemViewModel> temp = [];
            for (int i = 0; i < forecastData.list.length; i++) {
              temp.add(new RadialListItemViewModel(
                  icon: new NetworkImage(forecastData.list[i].icon),
                  title: '${new NumberFormat('###.##').format(
                      forecastData.list[i].temp)}℃',
                  subtitle: forecastData.list[i].main +
                      "\n" +
                      new DateFormat.yMMMd()
                          .format(forecastData.list[i].date)));
            }
            items = new RadialListViewModel(items: temp);
            //      print("help: $items");

            choices = [
              new HomeDisplay(
                title: 'home',
                hbotImg: hbotImg,
                hbotMsg: greetingMsg,
                startAt: startAt,
                dayProgress: dayProgress,
                user: currentUser,
                greeting: greetingMsg,
                slidingListController: slidingListController,
                radialList: items,
                deepShade: deepShade,
                mediumShade: mediumShade,
                shallowShade: shallowShade,
              ),
              new HomeDisplay(
                  error: error,
                  dayProgress: dayProgress,
                  hbotMsg: greetingMsg,
                  hbotImg: hbotImg,
                  startAt: startAt,
                  user: currentUser,
                  greeting: greetingMsg,
                  bgImg: bgImg,
                  isLoading: isLoading,
                  loadWeather: loadWeather,
                  location: _location,
                  forecastData: forecastData,
                  weatherData: weatherData,
                  title: 'weather')
            ];
          }
          openableController = new OpenableController(
            vsync: this,
            openDuration: const Duration(milliseconds: 250),
          )..addListener(() => setState(() {}));

          slidingListController = new SlidingRadialListController(
            itemCount: items.items.length,
            vsync: this,
          )..open();
        });
      }
    }

    setState(() {
      isLoading = false;
    });
    return "Success";
  }
}

class HomeDisplay extends StatelessWidget {
  final String dayProgress;
  final bool isMorning;
  final String hbotMsg;
  final String hbotImg;
  final double startAt;
  final bool isLoading;
  final WeatherData weatherData;
  final ForecastData forecastData;
  final Location location;
  final String error;
  final VoidCallback loadWeather;
  final List<double> stops;
  final String user;
  final String bgImg;
  final String greeting;
  final bool rain;
  final String title;
  final Color deepShade; //=new Color.fromRGBO(153, 230, 255, 1.0);
  final Color mediumShade; //=new Color.fromRGBO(204, 242, 255, 1.0);
  final Color shallowShade; //=new Color.fromRGBO(255, 255, 255, 1.0);
  final RadialListViewModel radialList;
  final Animation<double> animation;

  final OpenableController openableController;

  final SlidingRadialListController slidingListController;

  HomeDisplay(
      {this.loadWeather,
      this.animation,
      this.hbotImg,
      this.hbotMsg,
      this.isMorning,
      this.startAt,
      this.dayProgress,
      this.user,
      this.greeting,
      this.rain = false,
      this.openableController,
      this.radialList,
      this.slidingListController,
      this.bgImg,
      this.stops,
      this.error,
      this.location,
      this.forecastData,
      this.isLoading,
      this.weatherData,
      key,
      this.title,
      this.deepShade,
      this.mediumShade,
      this.shallowShade})
      : super(key: key);

  Widget speechBubble() {
    final bg = Colors.black54;

    final radius = BorderRadius.only(
      topRight: Radius.circular(15.0),
      bottomRight: Radius.circular(15.0),
      topLeft: Radius.circular(15.0),
    );
    return Column(
      children: <Widget>[
        Container(
          width: hbotMsg.length >= 50 ? 180.0 : null,
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Text(
                  hbotMsg,
                  style: TextStyle(fontFamily: 'Jua', color: Colors.white),
                ),
              ),
              /* Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Row(
                children: <Widget>[
                  Text(time,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 10.0,
                      )),
                  SizedBox(width: 3.0),
                  Icon(
                    icon,
                    size: 12.0,
                    color: Colors.black38,
                  )
                ],
              ),
            )*/
            ],
          ),
        )
      ],
    );
  }

  Widget popAnimation() {
    return AnimatedBuilder(
      animation: animation,
    );
  }

  @override
  Widget build(BuildContext context) {
    //  print(" Data: ${hbotImg}");
    if (title == 'weather') {
      return new Container(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new BackgroundWithRings(
              bgImg: bgImg,
            ),
            new Transform.translate(
              offset: const Offset(0.0, 73.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: weatherData != null
                        ? _Weather(weather: weatherData)
                        : Container(
                            color: Colors.red,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                new AlwaysStoppedAnimation(Colors.white),
                          )
                        : IconButton(
                            icon: new Icon(Icons.refresh),
                            tooltip: 'Refresh',
                            onPressed: loadWeather,
                            color: Colors.white,
                          ),
                  ),
                  radialList != null
                      ? new SlidingRadialList(
                          radialList: radialList,
                          controller: slidingListController,
                        )
                      : new Container(),
                  new Rain(),
                ],
              ),
            ),
            /* new Text(
                'WE•AT•HER',
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'ExoBold'

                )
            ),*/
          ],
        ),
      );
    } else {
      return new Container(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Center(
                child: new RoundProgress(
              timePercentage: dayProgress,
              dayProgressColor: shallowShade,
              currentTime: startAt,
              numStyle: TextStyle(
                  fontFamily: 'Exo', fontSize: 40.0, color: shallowShade),
            )),
            new Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    // color: Colors.white70,
                    height: 200.0,
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(children: <Widget>[
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: new Container(
                              // color: Colors.white30,
                              height: 60.0,
                              width: 60.0,
                              child: Image(
                                image: AssetImage(hbotImg),
                              ))),
                      Positioned(top: 90.0, left: 40.0, child: speechBubble())
                    ]))),
            /* new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(greeting,style: new TextStyle(fontFamily: 'IndieFlower',color: shallowShade.withRed(new Random().nextInt(255-90+1)+90),fontSize: 32.0),),
              new Text(user,style: new TextStyle(fontFamily: 'Jua',color: shallowShade.withRed( new Random().nextInt(255-90+1)+90),fontSize: 20.0),),
            ],))*/
          ],
        ),
      );
    }
  }
}

class _Weather extends StatelessWidget {
  final WeatherData weather;

  _Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('${new NumberFormat('###.##').format(weather.temp)}℃ ',
            style: new TextStyle(
                color: Colors.white, fontSize: 32.0, fontFamily: 'Audiowide')),
        Text(weather.name,
            style: new TextStyle(
                color: Colors.black45, fontFamily: 'IndieFlower')),
        Text(weather.main,
            style: new TextStyle(
              color: Colors.black45,
              fontSize: 18.0,
            )),
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
        //Text(new DateFormat.yMMMd().format(weather.date), style: new TextStyle(color: Colors.white)),
        //Text(new DateFormat.Hm().format(weather.date), style: new TextStyle(color: Colors.white)),
      ],
    );
  }
}

class WeatherItem extends StatelessWidget {
  final WeatherData weather;

  WeatherItem({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(weather.name, style: new TextStyle(color: Colors.black)),
            Text(weather.main,
                style: new TextStyle(color: Colors.black, fontSize: 24.0)),
            Text('${weather.temp.toString()}°F',
                style: new TextStyle(color: Colors.black)),
            Image.network(
                'https://openweathermap.org/img/w/${weather.icon}.png'),
            Text(new DateFormat.yMMMd().format(weather.date),
                style: new TextStyle(color: Colors.black)),
            Text(new DateFormat.Hm().format(weather.date),
                style: new TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard(
      {this.tabController,
      this.currentTime,
      this.currentDate,
      Key key,
      this.choice,
      this.isMorning})
      : super(key: key);

  final HomeDisplay choice;
  final Widget backgroundChild;
  final String currentTime;
  final String currentDate;
  final bool isMorning;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        choice,
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TabPageSelector(
                controller: tabController,
                color: Colors.black12,
                selectedColor: Colors.black54,
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(
                  currentTime,
                  style: new TextStyle(
                    color: isMorning
                        ? Colors.midnightTextSecnodary
                        : Colors.midnightTextPrimary,
                    fontFamily: 'ExoBold',
                    fontSize: 44.0,
                  ),
                ),
                new Text(
                  currentDate,
                  style: new TextStyle(
                    color: isMorning ? Colors.black45 : Colors.indigoAccent,
                    fontFamily: 'ExoBold',
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class BackgroundWithRings extends StatelessWidget {
  final String bgImg;

  BackgroundWithRings({this.bgImg});

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        /*new Image.asset(
          'assets/weather-bk_enlarged.png',
          fit: BoxFit.cover,
        ),*/

        new ClipOval(
          clipper: new CircleClipper(
            radius: 140.0,
            offset: const Offset(40.0, 0.0),
          ),
          child: new Transform.translate(
            offset: new Offset(0.0, 100.0),
            child: new Image(
              image: new AssetImage('images/blank.png'),
              fit: BoxFit.scaleDown,
              height: 70.0,
              width: 90.0,
            ),
          ),
        ),
        new CustomPaint(
          painter: new WhiteCircleCutoutPainter(
              centerOffset: const Offset(40.0, 0.0),
              circles: [
                new Circle(radius: 140.0, alpha: 0x10),
                new Circle(radius: 140.0 + 15.0, alpha: 0x28),
                new Circle(radius: 140.0 + 30.0, alpha: 0x38),
                new Circle(radius: 140.0 + 75.0, alpha: 0x50),
              ]),
          child: new Container(),
        )
      ],
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  final double radius;
  final Offset offset;

  CircleClipper({
    this.radius,
    this.offset = const Offset(0.0, 0.0),
  });

  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(0.0, size.height / 2) + offset,
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class WhiteCircleCutoutPainter extends CustomPainter {
  final Color overlayColor = const Color(0xFFAA88AA);

  final List<Circle> circles;
  final Offset centerOffset;
  final Paint whitePaint;
  final Paint borderPaint;

  WhiteCircleCutoutPainter({
    this.circles = const [],
    this.centerOffset = const Offset(0.0, 0.0),
  })  : whitePaint = new Paint(),
        borderPaint = new Paint() {
    borderPaint
      ..color = const Color(0x10FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 1; i < circles.length; ++i) {
      _maskCircle(canvas, size, circles[i - 1].radius);

      whitePaint.color = overlayColor.withAlpha(circles[i - 1].alpha);

      // Fill circle
      canvas.drawCircle(
        new Offset(0.0, size.height / 2) + centerOffset,
        circles[i].radius,
        whitePaint,
      );

      // Draw circle bevel
      canvas.drawCircle(
        new Offset(0.0, size.height / 2) + centerOffset,
        circles[i - 1].radius,
        borderPaint,
      );
    }

    // Mask the area of the final circle
    _maskCircle(canvas, size, circles.last.radius);

    // Draw an overlay that fills the rest of the screen.
    whitePaint.color = overlayColor.withAlpha(circles.last.alpha);
    canvas.drawRect(
      new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      whitePaint,
    );

    // Draw the bevel for the final circle.
    canvas.drawCircle(
      new Offset(0.0, size.height / 2) + centerOffset,
      circles.last.radius,
      borderPaint,
    );
  }

  _maskCircle(Canvas canvas, Size size, double radius) {
    Path clippedCircle = new Path();
    clippedCircle.fillType = PathFillType.evenOdd;
    clippedCircle.addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    clippedCircle.addOval(
      new Rect.fromCircle(
        center: new Offset(0.0, size.height / 2) + centerOffset,
        radius: radius,
      ),
    );
    canvas.clipPath(clippedCircle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Circle {
  final double radius;
  final int alpha;

  Circle({
    this.radius,
    this.alpha = 0xFF,
  });
}
