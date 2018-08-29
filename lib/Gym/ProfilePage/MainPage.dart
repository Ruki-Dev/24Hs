import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twenty_four_hours/Authentication/RegisterForm.dart';
import 'package:twenty_four_hours/Gym/Models/CreateAccounts.dart';
import 'package:twenty_four_hours/Gym/Awards/BronzeDialog.dart';
import 'package:twenty_four_hours/Gym/Awards/GoldDialog.dart';
import 'package:twenty_four_hours/Gym/Awards/SilverDialog.dart';
import 'package:twenty_four_hours/Gym/Models/Profile.dart';
import 'package:twenty_four_hours/Gym/ProfilePage/homePage.dart';
import 'package:twenty_four_hours/Widget_Assets/ChipTile.dart';
import 'package:twenty_four_hours/Widget_Assets/ColapsablePanels.dart';
import 'package:twenty_four_hours/Widget_Assets/FollowingDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/FollowersDialog.dart';
import 'package:twenty_four_hours/Widget_Assets/MutualDialog.dart';

class MainPage extends StatelessWidget {
  final Profile profile;
  final Profile me;

  MainPage({this.profile, this.me});

  @override
  Widget build(BuildContext context) {
    return Home(profile: profile, me: me);
  }
}

class Home extends StatefulWidget {
  final String title;
  final Profile profile;
  final Profile me;

  Home({Key key, this.title, this.me, this.profile}) : super(key: key);

  HomeState createState() => new HomeState(profile: profile, myProfile: me);
}

class RIKeys {
  static List<Key> riKey = [const Key('__RIKEY1__')];

  static Key generateKeys(int indexOfKey) {
    for (int i = 0; i < 100; i++) riKey.add(Key('KEY_$i'));
    if (indexOfKey <= 100) {
      return riKey[indexOfKey];
    } else
      return Key('Key_${UsernameGenerator().getUsername()}');
  }
}

class HomeState extends State<Home> {
  final Profile profile;
  final Profile myProfile;
  bool followed, friended;
  String numFollower;

  HomeState({this.profile, this.myProfile});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<CollapseItem<dynamic>> _historyItems;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Build HERE
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: _nameToColor(profile.user.username),
        title: new Text(
          profile.user.username,
          style: new TextStyle(fontFamily: 'Jua', color: Colors.white),
        ),
        actions: <Widget>[
          new PopupMenuButton<Choice>(
              key: RIKeys.generateKeys(0),
              onSelected: _select,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
                    PopupMenuItem<Choice>(
                      value: new Choice(title: 'Add'),
                      child: new Text(
                        friended ? 'Invite Pending...' : 'Add as Friend',
                        style: new TextStyle(
                            color: Colors.mainscreenDark,
                            fontFamily: 'Exo-Light',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    PopupMenuItem<Choice>(
                      value: new Choice(title: 'Invite'),
                      child: new Text(
                        'Invite To Group',
                        style: new TextStyle(
                            color: Colors.mainscreenDark,
                            fontFamily: 'Exo-Light',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
        ],
      ),
      body: new SingleChildScrollView(
        key: RIKeys.generateKeys(1),
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          key: RIKeys.generateKeys(2),
          children: <Widget>[
            /* new Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        overflow: Overflow.clip,
        */
            profile.UID == myProfile.UID
                ? new Container()
                : new Row(
                    key: RIKeys.generateKeys(3),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Column(
                                children: <Widget>[
                                  new IconButton(
                                    onPressed: () {
                                      _handleFriended();
                                    },
                                    icon: friended
                                        ? Icon(
                                            Icons.people,
                                            color: _nameToColor(
                                                profile.user.username),
                                          )
                                        : Icon(Icons.people_outline,
                                            color: _nameToColor(
                                                profile.user.username)),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: new Text(
                                        friended
                                            ? 'Add Friend'
                                            : 'Invite Pending..',
                                        style: new TextStyle(
                                          color: friended
                                              ? Colors.black38
                                              : _nameToColor(
                                                  profile.user.username),
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Column(
                                children: <Widget>[
                                  new IconButton(
                                    onPressed: () {
                                      _openMutualDialog(context, myProfile);
                                    },
                                    icon: Icon(Icons.wc,
                                        color: _nameToColor(
                                            profile.user.username)),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: new Text(
                                        '${myProfile.friends
                              .getMutualFriend(profile)
                              .length} Mutual Friends',
                                        style: new TextStyle(
                                          color: friended
                                              ? Colors.black38
                                              : _nameToColor(
                                                  profile.user.username),
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ]),
            new Center(
              key: RIKeys.generateKeys(4),
              child: new Column(
                key: RIKeys.generateKeys(5),
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        const BoxShadow(
                            color: Colors.black12,
                            offset: const Offset(0.0, 0.0))
                      ],
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    child: new GestureDetector(
                      onTap: () => _openPicture(context),
                      child: new CircleAvatar(
                        radius: 50.0,
                        backgroundColor: _nameToColor(profile.user.username),
                        backgroundImage:
                            new NetworkImage(profile.user.profile_pic_url),
                      ),
                    ),
                  ),
                  new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Column(
                        children: <Widget>[
                          new Text(profile.user.username,
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Jua',
                                  fontSize: 20.0),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.fade),
                          new Text(
                              '${profile.user.first_name} • ${profile.user
                              .second_name}',
                              style: new TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Jua',
                                  fontSize: 13.0),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.fade),
                        ],
                      )),
                ],
              ),
            ),
            new Padding(
                padding: const EdgeInsets.all(12.0),
                child: new Row(
                  key: RIKeys.generateKeys(6),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new IconButton(
                            onPressed: profile.UID == myProfile.UID
                                ? () {
                                    _openFollowersDialog(context);
                                  }
                                : () {
                                    _handleFollow();
                                  },
                            icon: new Icon(
                                followed || profile.UID == myProfile.UID
                                    ? FontAwesomeIcons.solidHandRock
                                    : FontAwesomeIcons.handPaper,
                                color: followed ? Colors.blue : Colors.black38),
                          ),
                          new Text(
                            numFollower,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Jua',
                                color: followed ? Colors.blue : Colors.black38),
                          )
                        ],
                      ),
                    ),
                    new Row(
                      key: RIKeys.generateKeys(8),
                      children: <Widget>[
                        new Column(
                          key: RIKeys.generateKeys(9),
                          children: <Widget>[
                            new IconButton(
                                onPressed: _openGoldDialog,
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color: Colors.midnightTextPrimary,
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getVal(profile.awards.totalGold.amount),
                                style: new TextStyle(
                                    color: Colors.midnightTextPrimary,
                                    fontFamily: 'Jua'),
                              ),
                            ),
                          ],
                        ),
                        new Column(
                          key: RIKeys.generateKeys(7),
                          children: <Widget>[
                            new IconButton(
                                onPressed: _openSilverDialog,
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color:
                                        new Color.fromRGBO(191, 191, 191, 1.0),
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getVal(profile.awards.totalSilver.amount),
                                style: new TextStyle(
                                    color:
                                        new Color.fromRGBO(191, 191, 191, 1.0),
                                    fontFamily: 'Jua'),
                              ),
                            ),
                          ],
                        ),
                        new Column(
                          key: RIKeys.generateKeys(10),
                          children: <Widget>[
                            new IconButton(
                                onPressed: _openBronzeDialog,
                                icon: new Icon(FontAwesomeIcons.trophy,
                                    color:
                                        new Color.fromRGBO(191, 128, 64, 1.0),
                                    size: 25.0)),
                            new Transform.translate(
                              offset: new Offset(2.0, 1.0),
                              child: new Text(
                                getVal(profile.awards.totalBronze.amount),
                                style: new TextStyle(
                                    color:
                                        new Color.fromRGBO(191, 128, 64, 1.0),
                                    fontFamily: 'Jua'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                        key: RIKeys.generateKeys(11),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new IconButton(
                            onPressed: () {
                              _openFollowingDialog(context);
                            },
                            icon: new Icon(
                              FontAwesomeIcons.solidHandsHelping,
                              color: Colors.black38,
                            ),
                          ),
                          new Text(
                            getFollowings(),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Jua',
                              color: Colors.black38,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            new Divider(),
            new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Column(
                  key: RIKeys.generateKeys(12),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text('Bio',
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Jua',
                                  fontSize: 20.0),
                              maxLines: 1,
                              overflow: TextOverflow.fade),
                          profile.UID == myProfile.UID
                              ? new IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _bioBox(context);
                                  })
                              : new Container()
                        ]),
                    new Text('${profile.bio}',
                        style: new TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Jua',
                            fontSize: 13.0),
                        maxLines: 12,
                        overflow: TextOverflow.fade),
                  ],
                )),
            new Divider(),
            /* new Padding(padding: const EdgeInsets.all( 10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _historyItems[index].isExpanded = !isExpanded;
                      });

                  },
                  children: _historyItems.map((CollapseItem<dynamic> item) {
                    return new ExpansionPanel(
                        isExpanded: item.isExpanded,
                        headerBuilder: item.headerBuilder,
                        body: item.build()
                    );

                  }).toList()

              ),

            ],
          ))
      new Divider(),*/
            new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Column(
                  key: RIKeys.generateKeys(14),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text('Here are some people you might like...',
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: 'Jua',
                            fontSize: 15.0),
                        maxLines: 1,
                        overflow: TextOverflow.fade),
                    new ChipTile(label: '', children: suggestedChips()),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  List<Profile> _avatars = new List<Profile>();
  final Set<Profile> _tools = new Set<Profile>();

  List<Widget> suggestedChips() {
    if (_avatars != null && _avatars.isNotEmpty) {
      for (Profile p in _avatars) _tools.add(p);
    }
    final List<Widget> actionChips = _tools.map<Widget>((Profile p) {
      return new ActionChip(
        backgroundColor: _nameToColor(p.user.username),
        label: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Row(children: <Widget>[
            new CircleAvatar(
              backgroundImage: NetworkImage(p.user.profile_pic_url),
              radius: 20.0,
            ),
            new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(p.user.username,
                    style: new TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Jua',
                        color: Colors.white))),
          ]),
        ),
        onPressed: () {
          _openFollowingDialogP(context, p);
        },
      );
    }).toList();
    return actionChips;
  }

  @override
  void dispose() {
    profiles.clear();
    simmilar.clear();
  }

  Future _openMutualDialog(BuildContext context, Profile p) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new MutualDialog(myProfile: p);
        },
        fullscreenDialog: true));
  }

  Future _openFollowingDialog(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new FollowingDialog(myProfile: profile);
        },
        fullscreenDialog: true));
  }

  Future _openFollowersDialog(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new FollowerDialog(myProfile: profile);
        },
        fullscreenDialog: true));
  }

  Future _openFollowingDialogP(BuildContext context, Profile p) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Homepage(myProfile: myProfile, profile: p);
        },
        fullscreenDialog: true));
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  String getVal(int val) {
    return new NumberFormat.compact().format(val);
  }

  String getValue() {
    return new NumberFormat.compact().format(profile.follow.followers);
  }

  String getFollowings() {
    return new NumberFormat.compact().format(profile.follow.following);
  }

  @override
  void initState() {
    profiles.clear();
    simmilar.clear();
    followed = _checkIfFollowing();
    numFollower = getValue();
    friended = _isFriend();
    generateSimilarprofiless();
    _historyItems = <CollapseItem<dynamic>>[
      new CollapseItem<String>(
        name: '',
        value: 'Activity in the past 24 Hours',
        hint: '',
        valueToString: (String value) => value,
        builder: (CollapseItem<String> item) {
          void close() {
            setState(() {
              item.isExpanded = false;
            });
          }

          return new Form(
            child: new Builder(
              builder: (BuildContext context) {
                return new CollapsibleBody(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  onSave: () {
                    Form.of(context).save();
                    close();
                  },
                  onCancel: () {
                    Form.of(context).reset();
                    close();
                  },
                  child: new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: new Text('none'),
                            leading:
                                new CircleAvatar(child: new Icon(Icons.close)));
                      },
                      itemCount: 1,
                      itemExtent: 152.0,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    ];
  }

  bool _checkIfFollowing() {
    bool following = false;
    for (Profile p in myProfile.follow.followings) {
      print(p.user.username);
      if (p.UID == profile.UID) following = true;
    }
    //check if this profile is on current user's Follows
    return following;
  }

  void _handleFollow() {
    print(followed);
    if (!followed) {
      myProfile.follow.followings.add(profile);
      profile.follow.myFollowers.add(myProfile);
    } else {
      myProfile.follow.followings.remove(profile);
      profile.follow.myFollowers.remove(myProfile);

      print("Removed: ${profile.user
          .username} From Your Following\nNew Following: ${myProfile.follow
          .followings}");
    }
    setState(() {
      followed = _checkIfFollowing();
      numFollower = getValue();
      if (followed) {
        showInSnackBar('You started Following ${profile.user.username}');
      } else
        showInSnackBar('You just Unfollwed ${profile.user.username}');
    });
  }

  /*Widget _crossFade(Widget first, Widget second, bool isExpanded) {

    return new AnimatedCrossFade(

      firstChild: first,

      secondChild: second,

      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),

      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),

      sizeCurve: Curves.fastOutSlowIn,

      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,

      duration: const Duration(milliseconds: 200),

    );

  }*/

  Future _openGoldDialog() async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new GoldDialog(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }

  Future _openSilverDialog() async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new SilverDialog(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }

  Future _openBronzeDialog() async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new BronzeDialog(
            profile: profile,
          );
        },
        fullscreenDialog: true));
  }

/*Widget HistoryCards()
{

}*/
  List<Profile> profiles = new List<Profile>();
  List<Profile> simmilar = new List<Profile>();

  void generateSimilarprofiless() {
    profiles.clear();
    profiles = [
      CreateAccounts().ollie(),
      CreateAccounts().jcole(),
      CreateAccounts().Anika(),
      CreateAccounts().Teyana(),
      CreateAccounts().IronMan()
    ];
    int count = 0;
    simmilar = [];

    for (Profile p in profiles) {
      print('Profiles Here are: ${p.user.username}');
      for (String s in p.user.interest) {
        print(s);
        if (profile.user.interest.contains(s)) count++;
      }
      if (count > 2) {
        if (p.UID != myProfile.UID) simmilar.add(p);
      }
    }
    for (Profile p in profiles) {
      print('suggested: ${p.user.username}');
      if (p.UID != myProfile.UID) _avatars.add(p);
    }
  }

  bool _isFriend() {
    bool friends = false;
    for (Profile p in myProfile.friends.friends) {
      if (p.UID == profile.UID) friends = true;
    }
    return friends;
  }

  void _handleFriended() {
    print(friended);
    if (!friended) {
      myProfile.friends.friends.add(profile);
      profile.friends.friendInvites.add(myProfile);
    } else {
      myProfile.friends.friends.remove(profile);
      profile.friends.friendInvites.remove(myProfile);

      // print("Removed: ${profile.user.username} From Your Following\nNew Following: ${myProfile.follow.followings}");

    }
    setState(() {
      friended = _checkIfFollowing();
      if (friended) {
        showInSnackBar('Sent ${profile.user.username} A Friend Invite');
      } else
        showInSnackBar('${profile.user.username} is No Longer A Friend');
    });
  }

  void _select(Choice value) {}

  Future<Null> _openPicture(context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              actions: <Widget>[
                new IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: new Icon(Icons.close))
              ],
              content: new Container(
                child: FadeInImage.assetNetwork(
                    placeholder: 'images/big_CircleLoader.gif',
                    image: profile.user.profile_pic_url),
              ));
        });
  }

  Future<Null> _bioBox(context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Bio'),
            content: new TextFormField(
              controller: biocont,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tell us about yourself',
                helperText: 'Talk About what makes you Unique',
                labelText: 'About Me',
              ),
              maxLines: 4,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update Bio',
                    style: TextStyle(
                        color: biocont.text.isEmpty
                            ? Colors.lightBlueAccent
                            : Colors.lightBlueAccent)),
                textColor: Colors.lightBlue,
                onPressed: () {
                  setState(() {
                    profile.bio = biocont.text;
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  TextEditingController biocont = TextEditingController();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Add', icon: Icons.account_circle),
  const Choice(title: 'Invites', icon: Icons.home),
  const Choice(title: 'Login', icon: Icons.exit_to_app)
];
