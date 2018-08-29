import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:twenty_four_hours/Authentication/LoginForm.dart';
import 'package:twenty_four_hours/Authentication/RegisterActivity.dart';
import 'package:twenty_four_hours/Authentication/RegisterForm.dart';
import 'package:twenty_four_hours/Widget_Assets/InputFields.dart';

class LoginActivityMain extends StatefulWidget {
  LoginActivityMain({this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  _LoginActivity createState() => new _LoginActivity();
}

class _LoginActivity extends State<LoginActivityMain>
    with SingleTickerProviderStateMixin {
  Choice _selectedChoice = choices[0]; // The app's "state".
  List<String> _usernamees = [];
  List<String> _emails = [];
  bool enableButton = false;
  int emptyFields = 2;
  static var ub_color = Colors.midnightAccent;
  static var usernameIcon = new Icon(
    Icons.person_outline,
    color: Colors.white,
  );
  var passwordIcon = new Icon(
    Icons.lock,
    color: Colors.orange,
  );

  var myController;
  static TextEditingController _controller = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();

  var usernameForm;
  FocusNode _textFocus = new FocusNode();

  bool _obsecureText = true;

  var _passwordKey;

  // Login login=new Login();
  populateLists() {
    print('here');
    for (Register users in userInfos) {
      _usernamees.add(users.username.toLowerCase());
      _emails.add(users.email.toLowerCase());
      print(_emails);
    }
  }

  FirebaseUser user;
  FirebaseAuth Fauth;
  List<UIDs> uids = [];
  Register userInfo;
  List<Register> userInfos = List();
  String UID = '';
  DatabaseReference reference;

  _onEntryAdded(Event event) {
    setState(() {
      userInfos.add(new Register.fromSnapshot(event.snapshot));
      print(userInfos);
      populateLists();
    });
  }

  _onEntryAdded2(Event event) {
    setState(() {
      uids.add(new UIDs.fromSnapshot(event.snapshot));
      for (UIDs info in uids) {
        print(info.uid);
        reference
            .child("User_Information")
            .child(info.uid)
            .onChildAdded
            .listen(_onEntryAdded);
      }
    });
  }

  _Login(String email, String password) {
    Fauth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(onChange);
    reference = FirebaseDatabase.instance.reference();

    reference.child("User_Information").onChildAdded.listen(_onEntryAdded2);

    //_textFocus.addListener(onChange);
  }

  void _navTo(String route) {
    Navigator.of(context).pushNamed("/$route");
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      print(choice.title);
      if (_selectedChoice.title == 'Register') {
        _navTo("Register");
      } else if (_selectedChoice.title == 'home') {
        _navTo('Home');
      } else if (_selectedChoice.title == 'Login') {
        _navTo('Login');
      }
    });
  }

  CurvedAnimation curve;

  AnimationController controller;

  void tickAnimation({Duration dur = const Duration(milliseconds: 500)}) {
    controller = new AnimationController(
      duration: dur,
      vsync: this,
    );

    curve = Tween(begin: 0.0, end: 500).animate(controller)
      ..addListener(() {
        setState(() {
          //frame update
        });
      });
    controller.forward();
    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }
    //curve=new CurvedAnimation(parent: null, curve: Curves.bounceIn);
  }

  static String usernsmeErr = 'Empty Field!';

  bool _checkIfUsernameisValid(String val) {
    if (val.isEmpty) {
      if (_usernamees.contains(val) || _emails.contains(val)) {
        return true;
      } else
        return false;
    } else
      return false;
  }

  String _isValidUsername(String val) {
    if (val.isEmpty) {
      if (_usernamees.contains(val) || _emails.contains(val)) {
        return null;
      } else
        return 'Oops, This User Does not Exists';
    } else
      return 'Field Required!';
  }

  void _checkIfExistingUser() {
    String user = textEditingController.text;
    setState(() {
      if (user.isNotEmpty) {
        if (_usernamees.contains(user) || _emails.contains(user)) {
          usernameField = new InputFieldArea(
            hint: "Username/Email",
            obscure: false,
            icon: Icons.beenhere,
            color: Colors.green,
            hint_color: Colors.midnightTextPrimary,
            fontFamily: 'Jua',
            letterSpacing: 1.0,
            fontSize: 18.0,
            containerHeight: 60.0,
          );
        } else {
          usernameField = new InputFieldArea(
              hint: "Username/Email",
              obscure: false,
              icon: Icons.person_outline,
              color: Colors.red,
              hint_color: Colors.midnightTextPrimary,
              fontFamily: 'Jua',
              letterSpacing: 1.0,
              fontSize: 18.0,
              containerHeight: 60.0,
              neg_validatorBool:
                  !(_usernamees.contains(user) || _emails.contains(user)),
              errMsg: 'This user does not exist');
        }
      } else {}
    });
  }

  void onChange() {
    String text = _controller.text;
    String pass = _controller2.text;

    // bool hasFocus = _textFocus.hasFocus;
    //do your text transforming
    String username = text.toLowerCase();
    print("Usernames: $_usernamees \nUsername: $username\nPassword: $pass");

    setState(() {
      if (_checkIfUsernameisValid(_controller.text)) {
        SaveAndValidate;
      } else {
        usernameIcon = new Icon(
          Icons.person_outline,
          color: Colors.white,
        );
      }
      //_controller.text = newText;
      _controller.selection = new TextSelection(
          //baseOffset: newText.length,
          //extentOffset: newText.length
          );
    });
  }

  InputFieldArea usernameField;

  static TextEditingController _ucontroller = new TextEditingController();

  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  TextEditingController textEditingController = new TextEditingController();

  void SaveAndValidate() {
    final formState = _formKey.currentState;
    if (formState.validate()) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    usernameField = new InputFieldArea(
      hint: "Username/Email",
      obscure: false,
      icon: Icons.person_outline,
      color: Colors.white,
      hint_color: Colors.midnightTextPrimary,
      fontFamily: 'Jua',
      letterSpacing: 1.0,
      fontSize: 18.0,
      containerHeight: 60.0,
    );
    usernameForm = new Form(
      key: _formKey,
      child: new Container(
        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
        height: 60.0,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
          border: new Border.all(
              color: Colors.green, width: 2.5, style: BorderStyle.solid),
          color: Colors.transparent,
        ),
        child: new TextFormField(
          obscureText: false,

          controller: _controller,
          //focusNode: _textFocus,
          validator: (value) {
            _isValidUsername(value);
          },
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Jua',
            letterSpacing: 1.0,
            fontSize: 18.0,
          ),

          decoration: new InputDecoration(
            icon: usernameIcon,
            border: InputBorder.none,
            labelText: 'Username or Email',
            labelStyle:
                TextStyle(color: Colors.midnightTextPrimary, fontSize: 18.0),
          ),
        ),
      ),
    );

    //var icns=[new Icon(Icons.person_outline),new Icon(Icons.check_circle)]
    List<Widget> menu = <Widget>[
      new IconButton(
        icon: new Icon(choices[0].icon),
        color: new Color.fromRGBO(255, 215, 0, 1.0),
        onPressed: () {
          _select(choices[0]);
        },
      ),

      // overflow menu
      new PopupMenuButton<Choice>(
        onSelected: _select,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
              PopupMenuItem<Choice>(
                value: new Choice(title: 'home', icon: Icons.home),
                child: new Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    new Text(
                      choices[1].title,
                      style: new TextStyle(
                          color: Colors.mainscreenDark,
                          fontFamily: 'Exo-Light',
                          fontWeight: FontWeight.bold),
                    ),
                    new IconButton(
                      icon: new Icon(choices[1].icon),
                    )
                  ],
                ),
              ),
            ],
      ),
    ];

    return new Scaffold(
      appBar: new AppBar(
          actions: menu,
          title: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.all(5.0),
                child: new Text("Login",
                    style: new TextStyle(
                      color: Colors.midnightAccent,
                      fontSize: 22.0,
                      fontFamily: 'ExoLight',
                      fontWeight: FontWeight.bold,
                    )),
              ),
              new Container(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: new Text('Welcome back!',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      // fontFamily: 'ExoLight',
                    )),
              ),
            ],
          ),
          backgroundColor: Colors.mainscreenDark),
      body: new Container(
        color: Colors.midnight_main,
        padding: EdgeInsets.only(top: 70.0, left: 10.0, right: 10.0),
        child: SafeArea(
          top: false,
          bottom: false,
          child: new SingleChildScrollView(
            //child: new SingleChildScrollView(
            //padding: const EdgeInsets.only(top:150.0,left: 16.0,right: 16.0),
            child: new Container(
                padding:
                    const EdgeInsets.only(top: 150.0, left: 16.0, right: 16.0),
                height: 1000.0,
                decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(15.0)),
                    color: Colors.mainscreenDark,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black12,
                          offset: new Offset(0.5, 1.0),
                          blurRadius: 5.0,
                          spreadRadius: 3.0),
                    ]),
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new LoginForm(
                        passwordKey: _passwordKey,
                        users: _usernamees,
                        emails: _emails,
                      ),
                    ],
                  ),
                )),
          ),
          //),
        ),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Card(
      color: Colors.yellow,
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(
              choice.icon,
              size: 120.0,
              color: new Color.fromRGBO(255, 215, 0, 1.0),

              ///Gold
            ),
            new Text(
              choice.title,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Register', icon: Icons.account_circle),
  const Choice(title: 'Sign in as Guest', icon: Icons.home),
  const Choice(title: 'Login', icon: Icons.exit_to_app)
];
