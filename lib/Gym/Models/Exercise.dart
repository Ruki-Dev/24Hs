class Exercise {
  String _name = '';
  String _desc = '';
  String _tips = '';
  List<String> _muscles = [];
  String _imgurl = '';
  String _gifurl = '';
  String _level = '';
  int _sets = 0;
  int _reps = 0;
  double _weight = 0.0;
  String _category = '';
  Duration _time ;
  Duration _rest = new Duration();
  Duration _rest_per_set = new Duration();
  String _tempo = '';

  Exercise(
      [this._name,
        this._desc,
        this._tips,
        this._muscles,
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
    return 'Exercise{_name: $_name, _desc: $_desc, _tips: $_tips, _muscle: $_muscles, _imgurl: $_imgurl, _gifurl: $_gifurl, _level: $_level, _sets: $_sets, _reps: $_reps, _weight: $_weight, _category: $_category, _time: $_time, _rest: $_rest, _rest_per_set: $_rest_per_set, _tempo: $_tempo}';
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

  String get category => _category;

  set category(String value) {
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

  List<String> get muscles => _muscles;

  set muscles(List<String> value) {
    _muscles = value;
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

  static List<String> muscleGroups = [
    'Chest',
    'Core',
    'Biceps',
    'Triceps',
    'Shoulder',
    'Back',
    'Traps',
    'Glutes',
    'Quads',
    'Calves',
    'Cardio'
  ];
  static List<String> muscleGroups_ic = [
    'assets/ic_mg/ic_chest.png',
    'assets/ic_mg/ic_core.png',
    'assets/ic_mg/ic_biceps.png',
    'assets/ic_mg/ic_triceps.png',
    'assets/ic_mg/ic_shoulder.png',
    'assets/ic_mg/ic_back.png',
    'assets/ic_mg/ic_traps.png',
    'assets/ic_mg/ic_glutes.png',
    'assets/ic_mg/ic_quads.png',
    'assets/ic_mg/ic_calves.png',
    'images/runner.png'
  ];

  static translateImgtoName(String img) {
    switch (img.toLowerCase()) {
      case 'assets/ic_mg/ic_chest.png' :
        return 'Chest';
      case'assets/ic_mg/ic_core.png' :
        return 'Core';
      case 'assets/ic_mg/ic_biceps.png' :
        return 'Biceps';
      case 'assets/ic_mg/ic_triceps.png' :
        return 'Triceps';
      case 'assets/ic_mg/ic_shoulder.png' :
        return 'Shoulder';
      case 'assets/ic_mg/ic_back.png' :
        return 'Back';
      case 'assets/ic_mg/ic_traps.png' :
        return 'Traps';
      case 'assets/ic_mg/ic_glutes.png' :
        return 'Glutes';
      case 'assets/ic_mg/ic_quads.png' :
        return 'Quads';
      case 'assets/ic_mg/ic_calves.png' :
        return 'Calves';

      case 'images/runner.png' :
        return 'Cardio';
    }
  }
  static translateNametoImg(String name) {
    switch (name.toLowerCase().trim()) {
      case 'Chest' :
        return 'assets/ic_mg/ic_chest.png';
      case'Core' :
        return 'assets/ic_mg/ic_core.png';
      case 'Biceps' :
        return 'assets/ic_mg/ic_biceps.png';
      case 'Triceps' :
        return 'assets/ic_mg/ic_triceps.png';
      case 'Shoulder' :
        return 'assets/ic_mg/ic_shoulder.png';
      case 'Back' :
        return 'assets/ic_mg/ic_back.png';
      case 'Traps' :
        return 'assets/ic_mg/ic_traps.png';
      case 'Glutes' :
        return 'assets/ic_mg/ic_glutes.png';
      case 'Quads' :
        return 'assets/ic_mg/ic_quads.png';
      case 'Calves' :
        return 'assets/ic_mg/ic_calves.png';

      case 'Cardio' :
        return 'images/runner.png';
      default: return 'images/runner.png';
    }
  }
}
