import 'package:twenty_four_hours/Gym/Models/Videos.dart';

class VideoPlaylist {
  String _name = '';
  List<Videos> _videos = new List<Videos>();

  VideoPlaylist(this._name, this._videos);

  @override
  String toString() {
    return 'VideoPlaylist{_name: $_name, _videos: $_videos}';
  }

  List<Videos> get videos => _videos;

  set videos(List<Videos> value) {
    _videos = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}
