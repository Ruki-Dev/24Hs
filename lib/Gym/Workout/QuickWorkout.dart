import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class SearchWorkout extends SearchDelegate<Workout>
{

}


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
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Workout Colection"),
        actions: <Widget>[
          IconButton(icon:Icon(Icons.search),onPressed: (){},),
        ],
      ),
      key: Key("quickWorkout"),
      body: new Stack(
        fit: StackFit.expand,
        key: Key("qWstack1"),
        alignment: Alignment.center,
        children: <Widget>[
         genrateBluredImage(DecorationImage(
                image:AssetImage('images/gym1.jpg'),
                fit:BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
                colorFilter: new ColorFilter.mode(Colors.mainscreenDark, BlendMode.color)
            )),

        ],
      ),
    );
  }

  Widget genrateBluredImage(DecorationImage dim) {
    return new Container(
      decoration: new BoxDecoration(
          image: dim
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

}