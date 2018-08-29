import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lamp/lamp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/MainPage.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/MealPlans.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/Pics.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/Videos.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/WorkoutPlans.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/Chat.dart';
import 'package:flutter_radial_menu/flutter_radial_menu.dart';
import 'package:twenty_four_hours/Main/Uploads/CameraUpload.dart';

class Homepage extends StatefulWidget {
  final String UID;
  final Profile profile;
  final Profile myProfile;

  Homepage({Key key, this.profile, this.myProfile}) : super(key: key);

  HomepageState createState() =>
      HomepageState(profile: profile, myProfile: myProfile);
}

class HomepageState extends State<Homepage> with TickerProviderStateMixin {
  final TextEditingController controller = new TextEditingController();
  final TextEditingController acontroller = new TextEditingController();
  bool menutap = false;
  Color pageColor = Colors.red;
  TabController tabController;
  final Profile profile;
  final Profile myProfile;

  HomepageState({this.profile, this.myProfile});

  int _pageIndex = 0;
  final PageController _pageController = new PageController(initialPage: 1);

  List<CameraDescription> cameras;

  Future<Null> loadCams() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }

    _openCamera(context);
  }

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 3, vsync: this);
    //tabController.addListener();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    controller.dispose();
    acontroller.dispose();
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  @override
  Widget build(BuildContext context) {
    print(profile);
    // _nameToColor(profile.user.username)
    return new Scaffold(
      body: _page(_pageIndex),
      floatingActionButton: _pageIndex <= 1 || profile.UID == myProfile.UID
          ? FloatingActionButton.extended(
              label: Text(
                'Upload',
                style: TextStyle(),
              ),
              icon: Icon(Icons.file_upload),
              onPressed: () {
                _bioBox(context);
              },
              backgroundColor: Colors.purpleAccent,
            )
          : null,
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title:
                  new Text('About', style: new TextStyle(fontFamily: 'Jua'))),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.image),
              title: new Text('Pics', style: new TextStyle(fontFamily: 'Jua'))),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.ondemand_video),
              title:
                  new Text('Videos', style: new TextStyle(fontFamily: 'Jua'))),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.library_books),
              title: new Text('Workout Plan',
                  style: new TextStyle(fontFamily: 'Jua', fontSize: 11.0))),
          new BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.utensils),
              title: new Text('Meal Plans',
                  style: new TextStyle(fontFamily: 'Jua', fontSize: 12.0))),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.chat_bubble),
              title: new Text('Chat', style: new TextStyle(fontFamily: 'Jua'))),
        ],
        type: BottomNavigationBarType.fixed,
        fixedColor: _nameToColor(profile.user.username),
        onTap: (currentIndex) {
          setState(() {
            _pageIndex = currentIndex;
          });
        },
        currentIndex: _pageIndex,
      ),
    );
    // TODO: implement build
  }

  Widget _page(int currentpage) {
    List<Widget> pages = [
      new Scaffold(body: MainPage(profile: profile, me: myProfile)),
      new Scaffold(
          body: PicsPage(
        profile: profile,
        myProfile: myProfile,
      )),
      new Scaffold(
          body: VideosPage(
        profile: profile,
        myProfile: myProfile,
      )),
      new Scaffold(
        body: WorkoutPlansPage(
          profile: profile,
        ),
      ),
      new Scaffold(body: MealPlansPage(profile: profile)),
      new Scaffold(
        body: ChatPage(profile: profile),
      ),
    ];
    return pages[currentpage];
  }

  GlobalKey<RadialMenuState> _menuKey = new GlobalKey<RadialMenuState>();

  final List<RadialMenuItem<MenuOptions>> items = <RadialMenuItem<MenuOptions>>[
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.camera,
      child: new Icon(
        Icons.camera,
      ),
      iconColor: Colors.white,
      backgroundColor: Colors.blue[400],
      tooltip: 'Take Photo',
    ),
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.video,
      child: new Icon(
        Icons.videocam,
      ),
      iconColor: Colors.white,
      backgroundColor: Colors.green[400],
      tooltip: 'Make A Video',
    ),
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.cinema,
      child: new Icon(
        Icons.add_to_queue,
      ),
      iconColor: Colors.white,
      backgroundColor: Colors.yellow[400],
      tooltip: 'Upload  Video',
    ),
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.gallery,
      child: new Icon(
        Icons.add_a_photo,
      ),
      iconColor: Colors.white,
      backgroundColor: Colors.red[400],
      tooltip: 'Upload Video',
    ),
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.uploadWP,
      child: new Icon(
        Icons.file_upload,
      ),
      iconColor: Colors.white,
      backgroundColor: Colors.black,
      tooltip: 'Upload WP',
    ),
  ];

  Widget genrateBluredImage() {
    return new Container(
      width: 20.0,
      height: 20.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new NetworkImage(myProfile.user.profile_pic_url),
          fit: BoxFit.cover,
        ),
      ),
      //I blured the parent conainer to blur background image, you can get rid of this part
      child: new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: new Container(
          //you can change opacity with color here(I used black) for background.
          decoration: new BoxDecoration(color: Colors.black.withOpacity(0.7)),
        ),
      ),
    );
  }

  Future<Null> _bioBox(context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(menutap ? 'Select One' : 'Tap on the \u2630'),
            contentPadding: EdgeInsets.zero,
            content: new Stack(fit: StackFit.expand, children: <Widget>[
              genrateBluredImage(),
              Center(
                child: new RadialMenu(
                  key: _menuKey,
                  items: items,
                  radius: 100.0,
                  onSelected: _onItemSelected,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Select Upload Type',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontFamily: 'Lobster',
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]),
            actions: <Widget>[
              FlatButton(
                  child: Text('CLOSE', style: TextStyle(color: Colors.red)),
                  textColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  void _onItemSelected(dynamic value) {
    print('****$value');
    if (value == MenuOptions.camera) {
      loadCams();
    }
  }

  Future _openCamera(BuildContext context) async {
    //Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CameraUpload(myProfile: myProfile, cams: cameras);
        },
        fullscreenDialog: false));
  }
}

enum MenuOptions {
  camera,
  video,
  cinema,
  gallery,
  uploadWP,
}
