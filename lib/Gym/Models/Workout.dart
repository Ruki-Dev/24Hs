import 'package:twenty_four_hours/Gym/Models/Exercise.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class Workout {
  List<Exercise> _exercises = List<Exercise>();
  String _name = '';
  String _level = '';
  Profile _creator = new Profile();
  String _desc = '';
  int _rating = 0;
  List<Superset> superset = new List<Superset>();

  Workout(this._exercises, this._name, this._level, this._creator, this._desc,
      this._rating,
      {this.superset});

  @override
  String toString() {
    return 'Workout{_exercises: $_exercises, _name: $_name, _level: $_level, _creator: $_creator, _desc: $_desc, _rating: $_rating, superset: $superset}';
  }

  int get rating => _rating;

  set rating(int value) {
    _rating = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  Profile get creator => _creator;

  set creator(Profile value) {
    _creator = value;
  }

  String get level => _level;

  set level(String value) {
    _level = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<Exercise> get exercises => _exercises;

  set exercises(List<Exercise> value) {
    _exercises = value;
  }
}

class Superset {
  Exercise _first = new Exercise();
  Exercise _second = new Exercise();

  Superset(this._first, this._second);

  Exercise get second => _second;

  set second(Exercise value) {
    _second = value;
  }

  Exercise get first => _first;

  set first(Exercise value) {
    _first = value;
  }

  @override
  String toString() {
    return 'Superset{_first: $_first, _second: $_second}';
  }
}
