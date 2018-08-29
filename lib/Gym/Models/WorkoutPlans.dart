import 'package:twenty_four_hours/Gym/Models/MealPlans.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/Models/Workout.dart';

class WorkoutPlan {
  List<Workout> _workouts = new List();
  List<MealPlan> _mealPlans = new List();
  bool isActive = false;
  String status = '';
  Profile creator = Profile();
  DateTime dateCreated = new DateTime.now();
  int _rating = 0;
  String _description = '';
  String level = '';
  Duration period = Duration(days: 30);
  DateTime startOn = new DateTime.now();
  List<String> tags = List<String>();
}
