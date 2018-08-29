import 'package:twenty_four_hours/Gym/Models/Meal.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class MealPlan {
  List<Meal> breakfast = new List<Meal>();
  List<Meal> lunch = new List<Meal>();
  List<Meal> dinner = new List<Meal>();
  Duration breakfast_time = new Duration(hours: 9);
  Duration lunch_time = new Duration(hours: 13);
  Duration dinner_time = new Duration(hours: 19);
  Duration length = new Duration(days: 30);
  DateTime dateCreated = new DateTime.now();
  String _name = '';
  List<String> type = List<String>();
  List<String> tags = List<String>();
  Profile creator = Profile();
  String tip = '';

  MealPlan(this._name,
      {this.breakfast,
      this.lunch,
      this.dinner,
      this.breakfast_time,
      this.lunch_time,
      this.dinner_time,
      this.length,
      this.dateCreated,
      this.type,
      this.tags,
      this.tip});

  @override
  String toString() {
    return 'MealPlan{breakfast: $breakfast, lunch: $lunch, dinner: $dinner, breakfast_time: $breakfast_time, lunch_time: $lunch_time, dinner_time: $dinner_time, length: $length, dateCreated: $dateCreated, _name: $_name, type: $type, tags: $tags, tip: $tip}';
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}
