import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class SavedWorkout extends StatefulWidget
{
  final Profile profile;
  SavedWorkout({this.profile});
  SavedWorkoutState createState()=>new SavedWorkoutState(profile: profile);
}
class SavedWorkoutState extends State<SavedWorkout>
{
  final Profile profile;
  SavedWorkoutState({this.profile});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("init SW");
    return new Scaffold(
      //key: Key("savedWorkout"),
      body: new Stack(
        fit: StackFit.expand,
       // key: Key("sWstack1"),
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