import 'package:twenty_four_hours/Gym/Models/Achievements.dart';

class Award {
  List<GoldAward> _goldAwards;
  List<SilverAward> _silverAwards;
  List<BronzeAward> _bronzeAwards;
  Achievements _totalGold;
  Achievements _totalSilver;
  Achievements _totalBronze;

  Award([this._goldAwards, this._silverAwards, this._bronzeAwards]);

  Achievements get totalGold => new Achievements('Gold', _goldAwards.length);

  set totalGold(Achievements value) {
    _totalGold = value;
  }

  @override
  String toString() {
    return 'Award{_goldAwards: $_goldAwards, _silverAwards: $_silverAwards, _bronzeAwards: $_bronzeAwards, _totalGold: $_totalGold, _totalSilver: $_totalSilver, _totalBronze: $_totalBronze}';
  }

  List<dynamic> get bronzeAwards => _bronzeAwards;

  set bronzeAwards(List<dynamic> value) {
    _bronzeAwards = value;
  }

  List<dynamic> get silverAwards => _silverAwards;

  set silverAwards(List<dynamic> value) {
    _silverAwards = value;
  }

  List<dynamic> get goldAwards => _goldAwards;

  set goldAwards(List<dynamic> value) {
    _goldAwards = value;
  }

  Award.fromJson(Map<String, dynamic> json)
      : _goldAwards = json['gold'],
        _silverAwards = json['silver'],
        _bronzeAwards = json['bronze'];

  Award.fromJson1(Map<String, List<GoldAward>> json)
      : _goldAwards = json['gold'];

  Map<String, dynamic> toJson() =>
      {'gold': _goldAwards, 'silver': _silverAwards, 'bronze': _bronzeAwards};

  Achievements get totalSilver =>
      new Achievements('Silver', _silverAwards.length);

  set toalSilver(Achievements value) {
    _totalSilver = value;
  }

  Achievements get totalBronze =>
      new Achievements('Bronze', _bronzeAwards.length);

  set totalSilver(Achievements value) {
    _totalBronze = value;
  }
}

class GoldAward {
  String _title = '';
  String _description = '';
  int _id = 21345;
  bool _achieved = false;
  final DateTime dateTime = new DateTime.now();

  GoldAward([this._title, this._description, this._id, this._achieved]);

  bool get achieved => _achieved;

  set achieved(bool value) {
    _achieved = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}

class SilverAward {
  String _title = '';
  String _description = '';
  int _id = 123456;
  bool _achieved = false;
  final DateTime dateTime = new DateTime.now();

  SilverAward([this._title, this._description, this._id, this._achieved]);

  bool get achieved => _achieved;

  set achieved(bool value) {
    _achieved = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}

class BronzeAward {
  String _title = '';
  String _description = '';
  int _id = 12335456;
  bool _achieved = false;
  final DateTime dateTime = new DateTime.now();

  BronzeAward([this._title, this._description, this._id, this._achieved]);

  bool get achieved => _achieved;

  set achieved(bool value) {
    _achieved = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}
