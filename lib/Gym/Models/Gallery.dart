import 'package:twenty_four_hours/Gym/Models/Picture.dart';

class Gallery {
  List<Picture> _pictures = [];
  String _name;

  Gallery([this._pictures, this._name]);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<Picture> get pictures => _pictures;

  set pictures(List<Picture> value) {
    _pictures = value;
  }

  @override
  String toString() {
    return 'Gallery{_pictures: $_pictures, _name: $_name}';
  }
}
