import 'package:twenty_four_hours/Gym/Models/Profile.dart';

class Friends {
  List<Profile> _friends = [];
  List<Profile> _blocked = [];
  List<Profile> _bestFriends = [];
  List<Profile> _mutualFriend = [];
  List<Profile> _friendInvites = [];

  Friends(this._friends, this._blocked, this._bestFriends, this._mutualFriend,
      this._friendInvites);

  List<Profile> get friendInvites => _friendInvites;

  set friendInvites(List<Profile> value) {
    _friendInvites = value;
  }

  List<Profile> getMutualFriend(Profile p) {
    bool mutual = false;
    for (Profile profile in _friends) {
      if (p.friends.friends.contains(profile)) mutual = true;
    }
    if (mutual == true) {
      _mutualFriend.add(p);
    }
    return _mutualFriend;
  }

  set mutualFriend(List<Profile> value) {
    _mutualFriend = value;
  }

  List<Profile> get bestFriends => _bestFriends;

  set bestFriends(List<Profile> value) {
    _bestFriends = value;
  }

  List<Profile> get blocked => _blocked;

  set blocked(List<Profile> value) {
    _blocked = value;
  }

  List<Profile> get friends => _friends;

  set friends(List<Profile> value) {
    _friends = value;
  }
}
