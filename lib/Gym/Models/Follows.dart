import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class Follows {
  num _following = 0;
  num _followers = 0;
  bool _isFollow = false;
  List<Profile> _followings = [];
  List<Profile> _myFollowers = [];

  Follows([this._isFollow, this._followings, this._myFollowers]);

  List<Profile> get followings => _followings;

  set followings(List<Profile> value) {
    _followings = value;
  }

  @override
  String toString() {
    return 'Follows{_following: $_following, _followers: $_followers, _isFollow: $_isFollow, _followings: $_followings, _myFollowers: $_myFollowers}';
  }

  bool get isFollow => _isFollow;

  set isFollow(bool value) {
    _isFollow = value;
  }

  num get followers => _myFollowers.length;

  set followers(num value) {
    _followers = value;
  }

  num get following => _followings.length;

  set following(num value) {
    _following = value;
  }

  List<Profile> get myFollowers => _myFollowers;

  set myFollowers(List<Profile> value) {
    _myFollowers = value;
  }
}
