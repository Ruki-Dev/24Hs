import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class Comments {
  Profile _commenter = new Profile();
  String _commment = '';
  List<Profile> _likedComment = [new Profile()];
  List<List<String>> _replies = new List<List<String>>();
  DateTime _duration = new DateTime.now();

  Comments(
      [this._commenter, this._commment, this._likedComment, this._replies]);

  List<Profile> get likedComment => _likedComment;

  List<List<String>> get replies => _replies;

  set replies(List<List<String>> value) {
    _replies = value;
  }

  int getDuration(DateTime currentTime) {
    return _duration.difference(currentTime).inSeconds;
  }

  @override
  String toString() {
    return 'Comments{_commenter: $_commenter, _commment: $_commment, _likedComment: $_likedComment, _duration: $_duration}';
  }

  String get commment => _commment;

  set commment(String value) {
    _commment = value;
  }

  set likedComment(List<Profile> value) {
    _likedComment = value;
  }

  Profile get commenter => _commenter;

  set commenter(Profile value) {
    _commenter = value;
  }
}
