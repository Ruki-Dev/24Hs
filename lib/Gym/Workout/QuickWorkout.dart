import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class QuickWorkout extends StatefulWidget
{
  final Profile profile;
  QuickWorkout({this.profile});
  QuickWorkoutState createState()=>new QuickWorkoutState(profile: profile);
}
class QuickWorkoutState extends State<QuickWorkout>
{
  final Profile profile;
  QuickWorkoutState({this.profile});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("init QW");
    return new Scaffold(
      key: Key("quickWorkout"),
      body: new Stack(
        fit: StackFit.expand,
        key: Key("qWstack1"),
        alignment: Alignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 20.0,
                  colors: [Colors.black87,Colors.white10],

                )
            ),
          )
        ],
      ),
    );
  }

}