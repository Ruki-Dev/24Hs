import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class WorkoutPlansPage extends StatelessWidget {
  final Profile profile;

  WorkoutPlansPage({this.profile});

  @override
  Widget build(BuildContext context) {
    return WorkoutPlans();
  }
}

class WorkoutPlans extends StatefulWidget {
  final String title;

  WorkoutPlans({Key key, this.title}) : super(key: key);

  WorkoutPlansState createState() => new WorkoutPlansState();
}

class WorkoutPlansState extends State<WorkoutPlans> {
  @override
  Widget build(BuildContext context) {
    // TODO: Build HERE
    return Center(
      child: Text('WP', style: TextStyle(fontSize: 50.0)),
    );
  }
}
