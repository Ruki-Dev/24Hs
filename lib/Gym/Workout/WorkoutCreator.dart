import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class WorkoutCreator extends StatefulWidget
{
  final Profile profile;
  WorkoutCreator({this.profile});
  WorkoutCreatorState createState()=>new WorkoutCreatorState(profile: profile);
}
class WorkoutCreatorState extends State<WorkoutCreator>
{
  final Profile profile;
  WorkoutCreatorState({this.profile});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: Key("wcWorkout"),
      body: new Stack(
        fit: StackFit.expand,
        key: Key("WCstack1"),
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