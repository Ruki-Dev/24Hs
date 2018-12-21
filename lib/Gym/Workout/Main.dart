import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/Workout/Completed.dart';
import 'package:twenty_four_hours/Gym/Workout/QuickWorkout.dart';
import 'package:twenty_four_hours/Gym/Workout/SavedWorkout.dart';
import 'package:twenty_four_hours/Gym/Workout/WorkoutCreator.dart';

class WorkoutMain extends StatefulWidget{
  final Profile profile;
  final String title;
  WorkoutMain({this.profile,this.title});
  WorkoutMainState createState()=>new WorkoutMainState(profile: profile);
}
class WorkoutMainState extends State<WorkoutMain> with TickerProviderStateMixin{
  final Profile profile;
  TabController tabController;
  WorkoutMainState({this.profile});
  int _currentIndex = 0;
  Color pageColor=Colors.green;
  String pageTile='My Completed Workouts';
   List<Widget> _children ;

  @override
  initState() {
    super.initState();


    tabController = new TabController(length: 3, vsync: this);
    tabController.addListener(_onChanged);
  }

  void _onChanged() {
    setState(() {
      print(tabController.index);
      if (tabController.index == 0) {
        pageColor = Colors.green;
      } else if (tabController.index == 1) {
        pageColor = Colors.deepPurple;
      } else if (tabController.index == 2) {
        pageColor = Colors.amber;
      } else {
        pageColor = Colors.blue;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    print("Initializing....");
    // TODO: implement build
    _children = [
      new Completed(profile: profile),
      new QuickWorkout(profile: profile),
      new SavedWorkout(profile: profile),
      new WorkoutCreator(profile: profile)

    ];
      return Scaffold(

        body: new TabBarView(
          children: _children,
          controller: tabController,
        ),
        bottomNavigationBar: new Material(
          color: pageColor,
          child: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(FontAwesomeIcons.checkCircle),
                      new Text(
                        "Completed",
                        style: new TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              new Tab(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.play_arrow),
                      new Text(
                        "Start",
                        style: new TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              new Tab(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.play_for_work),
                      new Text(
                        "Saved",
                        style: new TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              new Tab(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.add,size: 30.0),
                      new Text(
                        "Create",
                        style: new TextStyle(color: Colors.white),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


}