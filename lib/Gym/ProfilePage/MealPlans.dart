import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class MealPlansPage extends StatelessWidget {
  final Profile profile;

  MealPlansPage({this.profile});

  @override
  Widget build(BuildContext context) {
    return MealPlans();
  }
}

class MealPlans extends StatefulWidget {
  final String title;

  MealPlans({Key key, this.title}) : super(key: key);

  MealPlansState createState() => new MealPlansState();
}

class MealPlansState extends State<MealPlans> {
  @override
  Widget build(BuildContext context) {
    // TODO: Build HERE
    return Center(
      child: Text('MP', style: TextStyle(fontSize: 50.0)),
    );
  }
}
