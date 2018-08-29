import 'package:firebase_database/firebase_database.dart';

class Register {
  String _username = 'GUEST';
  String _email = 'GUEST@gmail.com';
  String _first_name = 'Guest';
  String _second_name = '';
  String _DOB = '';
  DateTime _DateCreated = DateTime.now();
  String _sex = '';
  num _phone = 089000000;
  String _profile_pic_url = '';
  List<dynamic> _interests = [];
  String _profile_vid_url = '';

  // Register(this._username, this._email, this._first_name, this._second_name,
  //   this._DOB, this._sex, this._profile_pic_url, this._interests);

  Register(
      [this._username,
      this._email,
      this._first_name,
      this._second_name,
      this._DOB,
      this._DateCreated,
      this._sex,
      this._phone,
      this._profile_pic_url,
      this._interests,
      this._profile_vid_url]);

  List get interest => _interests;

  set interest(List interest) {
    _interests = interest;
  }

  num get phone => phone;

  set phone(num val) {
    _phone = val;
  }

  String get profile_pic_url => _profile_pic_url;

  set profile_pic_url(String value) {
    _profile_pic_url = value;
  }

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
  }

  DateTime get DateCreated => _DateCreated;

  String get DOB => _DOB;

  set DOB(String value) {
    _DOB = value;
  }

  String get second_name => _second_name;

  set second_name(String value) {
    _second_name = value;
  }

  String get first_name => _first_name;

  set first_name(String value) {
    _first_name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  Register.fromSnapshot(DataSnapshot snapshot)
      : _username = snapshot.value["username"],
        _email = snapshot.value["email"],
        _first_name = snapshot.value["first_name"],
        _second_name = snapshot.value["second_name"],
        _DOB = snapshot.value["DOB"],
        _sex = snapshot.value["sex"],
        _phone = snapshot.value["phone"],
        _DateCreated = new DateTime.fromMillisecondsSinceEpoch(
            snapshot.value["date_created"]),
        _profile_pic_url = snapshot.value["profile_pic"],
        _interests = snapshot.value["interest"];

  toJson() {
    return {
      "username": _username,
      "email": _email,
      "first_name": _first_name,
      "second_name": _second_name,
      "DOB": _DOB,
      "sex": _sex,
      "phone": _phone,
      "date_created": _DateCreated.millisecondsSinceEpoch,
      "profile_pic": _profile_pic_url,
      "interest": _interests
    };
  }

  String get profile_vid_url => _profile_vid_url;

  set profile_vid_url(String value) {
    _profile_vid_url = value;
  }

  List<dynamic> get interests => _interests;

  set interests(List<dynamic> value) {
    _interests = value;
  }

  @override
  String toString() {
    return 'Register{_username: $_username, _email: $_email, _first_name: $_first_name, _second_name: $_second_name, _DOB: $_DOB, _DateCreated: $_DateCreated, _sex: $_sex, _phone: $_phone, _profile_pic_url: $_profile_pic_url, _interests: $_interests, _profile_vid_url: $_profile_vid_url}';
  }
}
