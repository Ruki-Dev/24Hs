class Exercise {
  String _name = '';
  String _desc = '';
  String _tips = '';
  MuscleGroup _muscle = new MuscleGroup();
  String _imgurl = '';
  String _gifurl = '';
  String _level = '';
  int _sets = 0;
  int _reps = 0;
  double _weight = 0.0;
  Category _category = new Category();
  Duration _time = new Duration();
  Duration _rest = new Duration();
  Duration _rest_per_set = new Duration();
  String _tempo = '';

  Exercise(
      [this._name,
      this._desc,
      this._tips,
      this._muscle,
      this._imgurl,
      this._gifurl,
      this._level,
      this._sets,
      this._reps,
      this._weight,
      this._category,
      this._time,
      this._rest,
      this._rest_per_set,
      this._tempo]);

  @override
  String toString() {
    return 'Exercise{_name: $_name, _desc: $_desc, _tips: $_tips, _muscle: $_muscle, _imgurl: $_imgurl, _gifurl: $_gifurl, _level: $_level, _sets: $_sets, _reps: $_reps, _weight: $_weight, _category: $_category, _time: $_time, _rest: $_rest, _rest_per_set: $_rest_per_set, _tempo: $_tempo}';
  }

  String get tempo => _tempo;

  set tempo(String value) {
    _tempo = value;
  }

  Duration get rest_per_set => _rest_per_set;

  set rest_per_set(Duration value) {
    _rest_per_set = value;
  }

  Duration get rest => _rest;

  set rest(Duration value) {
    _rest = value;
  }

  Duration get time => _time;

  set time(Duration value) {
    _time = value;
  }

  Category get category => _category;

  set category(Category value) {
    _category = value;
  }

  double get weight => _weight;

  set weight(double value) {
    _weight = value;
  }

  int get reps => _reps;

  set reps(int value) {
    _reps = value;
  }

  int get sets => _sets;

  set sets(int value) {
    _sets = value;
  }

  String get level => _level;

  set level(String value) {
    _level = value;
  }

  String get gifurl => _gifurl;

  set gifurl(String value) {
    _gifurl = value;
  }

  String get imgurl => _imgurl;

  set imgurl(String value) {
    _imgurl = value;
  }

  MuscleGroup get muscle => _muscle;

  set muscle(MuscleGroup value) {
    _muscle = value;
  }

  String get tips => _tips;

  set tips(String value) {
    _tips = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}

class Category {
  final List<String> _category = [
    'BodyWeight',
    'Plyometric',
    'CrossFit',
    'Muscle Growth',
    'Strength',
    'Endurance',
    'REsistance',
    'Calesthetic',
    'Tabata',
    'HIIT'
  ];

  List<String> get category => _category;
}

class MuscleGroup {
  final List<String> muscleGroups = [
    'Chest',
    'Core',
    'Biceps',
    'Triceps',
    'Shoulder',
    'Back',
    'Traps',
    'Glutes',
    'Quads',
    'Calves'
  ];
  final List<String> muscleGroups_ic = [
    'ic_chest.png',
    'ic_core.png',
    'ic_biceps.png',
    'ic_triceps.png',
    'ic_shoulder.png',
    'ic_back.png',
    'ic_traps.png',
    'ic_glutes.png',
    'ic_quads.png',
    'ic_calves.png'
  ];
}
