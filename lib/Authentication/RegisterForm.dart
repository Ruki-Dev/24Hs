import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:twenty_four_hours/Authentication/Auth_Model/Register.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twenty_four_hours/Widget_Assets/ChipTile.dart';
import 'package:twenty_four_hours/Widget_Assets/DatePicker.dart';
import 'package:twenty_four_hours/Widget_Assets/ProfileImage.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key, this.title}) : super(key: key);
  final String title;

  _CreateRegisterForm createState() => new _CreateRegisterForm();
}

class _CreateRegisterForm extends State<RegisterForm> {
  File _image;
  FirebaseUser user;
  FirebaseAuth Fauth;
  List<UIDs> uids = [];

  Register register;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;

      defaultImages = false;
    });
  }

  Future takePic() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;

      defaultImages = false;
    });
  }

  void saveAuth(String password, String email) async {
    user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserUpdateInfo updateInfo = new UserUpdateInfo();
    updateInfo.displayName = username;
    updateInfo.photoUrl = _image.path;
    Fauth.updateProfile(updateInfo);
    await user.reload();
  }

  Register userInfo;
  List<Register> userInfos = List();
  DatabaseReference ref;

  void saveUserInformation() async {
    UID = user.uid;
    print("UID: $UID");
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    ref = FirebaseDatabase.instance.reference();
    ref.child("User_Information").child(UID).push().set(userInfo.toJson());

    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseStorage store = FirebaseStorage.instance;
    StorageReference path = store
        .ref()
        .child(UID + (userInfos.isNotEmpty ? "" : ""))
        .child("Profile")
        .child("profile_pic.png");
    StorageUploadTask uploadTask = path.putFile(_image);
  }

  _onEntryAdded(Event event) {
    setState(() {
      userInfos.add(new Register.fromSnapshot(event.snapshot));
    });
  }

  _onEntryAdded2(Event event) {
    setState(() {
      uids.add(new UIDs.fromSnapshot(event.snapshot));
      for (UIDs info in uids) {
        print(info._uid);
        reference
            .child("User_Information")
            .child(info._uid)
            .onChildAdded
            .listen(_onEntryAdded);
      }
    });
  }

  var formkey = new GlobalKey<FormState>();
  var formkey3 = new GlobalKey<FormState>();
  DateFormat dateFormat;
  static bool _validEmail = false;
  static bool _validName = false;
  static bool _validPassword = false;
  static bool _obscureText = true;
  List<String> _values = new List<String>();
  List<String> _MCC = new List<String>();
  List<String> countries = new List<String>();
  String _value;
  String _value2 = '93 ';
  var pick = '353';
  var snackbar;

  DateTime _fromDate = new DateTime.now();
  String generatedUsername = new UsernameGenerator().getUsername();
  var ageError = new Text('');
  String username = '';
  String password = '';
  String email = '';
  String fn = '', sn = '', sex = 'Male', phone_no = '';
  DateTime birthday = new DateTime.now();

  static TextEditingController _controller = new TextEditingController();
  static TextEditingController _econtroller = new TextEditingController();
  static TextEditingController _pcontroller = new TextEditingController();

  static TextEditingController _ucontroller = new TextEditingController();
  static TextEditingController _fncontroller = new TextEditingController();
  static TextEditingController _sncontroller = new TextEditingController();
  static TextEditingController _phoneController = new TextEditingController();

  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      new _UsNumberTextInputFormatter();
  var mainformkey;
  int radioValue = 0;
  bool switchValue = false;
  bool defaultImages = true;

  var isTwoCompleted = false;

  var isThreeCompleted = false;
  var isFourCompleted = true;
  var isFiveCompleted = false;
  var isSixCompleted = false;
  var isSevenCompleted = false;
  bool isAllComplete = false;

  String userInitials = 'A';

  var phoneSupplied = false;
  List<String> _interests = [
    'Health & fitness',
    'Blogging',
    'Cooking',
    'Music',
    'Hip-Hop',
    'R&B',
    'Rock',
    'Pop',
    'Jazz',
    'Movies',
    'Tv',
    'Concerts',
    'Tech',
    'Books',
    'Science',
    'Plants',
    'Basketball',
    'Soccer',
    'American Football',
    'Rugby',
    'Sports',
    'Travel',
    'Games',
    'Photography',
    'Art',
  ];
  Set<String> selectedIntrests;
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  String error;

  bool currentWidget = true;

  @override
  void dispose() {
    _controller.dispose();
    _ucontroller.dispose();
    _econtroller.dispose();
  }

  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      location = await _location.getLocation;
      print(location);

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;

    setState(() {
      _startLocation = location;
    });
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      if (radioValue == 0)
        sex = 'Male';
      else if (radioValue == 1)
        sex = 'Female';
      else
        sex = 'other';
    });
  }

  var formkey2 = new GlobalKey<FormState>();

  generateName() {
    generatedUsername = new UsernameGenerator().getUsername();
    print(generatedUsername);
  }

  bool isValidBirthday() {
    print("age: ${new DateTime.now().year - _fromDate.year}");
    if (new DateTime.now().year - _fromDate.year >= 6) {
      return true;
    } else {
      return false;
    }
  }

  void SaveAndValidate() {
    final formState = formkey.currentState;
    if (formState.validate())
      setState(() {
        isOneCompleted = true;
      });
    else
      isOneCompleted = false;
  }

  void SaveAndValidate2() {
    final formState = formkey2.currentState;
    if (formState.validate())
      setState(() {
        isTwoCompleted = true;
        userInitials = fn.substring(0, 1);
        if (sn.isNotEmpty) {
          userInitials += " " + sn.substring(0, 1);
        }
      });
    else
      isTwoCompleted = false;
  }

  void SaveAndValidate3() {
    final formState = formkey3.currentState;
    if (formState.validate())
      setState(() {
        isFiveCompleted = true;
      });
    else
      isFiveCompleted = false;
  }

  void divideValues() {
    var temp;
    if (_values.isNotEmpty)
      for (String s in _values) {
        temp = s.split(':');
        _MCC.add(temp[1]);
        countries.add(temp[0]);
      }
  }

  String __isValidName(String name) {
    if (name.isEmpty) {
      _validName = false;
      return 'Field Required';
    } else
      return null;
  }

  String _isValidUser(String name) {
    if (name.isNotEmpty) {
      if (isUserExisting(name)) {
        return null;
      } else
        return 'Username $name is Taken ';
    } else
      return 'Empty Field!';
  }

  String _isValidEmail(String email) {
    if (email.isNotEmpty) {
      if (email.contains('@')) {
        if (isUserExisting(email)) {
          return null;
        }
        return 'This User Already Exists';
      } else
        return 'Email must contain @ ';
    } else
      return 'Empty Field!';
  }

  bool validEmail(String email) {
    if (email.isNotEmpty) {
      if (email.contains('@')) {
        return true;
      } else
        return false;
    } else
      return false;
  }

  String isValidPassword(String password) {
    password = password.trim();
    password = password.replaceAll(" ", "");
    RegExp regExp = new RegExp(".*[A-Z]+.*");
    RegExp regExp1 = new RegExp(".*[a-z]+.*");
    RegExp regExp2 = new RegExp(".*[0-9]+.*");
    // userDetails.add(new ArrayList<String>());
    int T = 0, F = 0;

    if (password.length >= 8) {
      if (regExp.allMatches(password).isNotEmpty) {
        print(regExp.allMatches(password));
        if (regExp1.allMatches(password).isNotEmpty) {
          if (regExp2.allMatches(password).isNotEmpty) {
            return null;
          } else {
            return "Must have a Number";
          }
        } else {
          return "Lowercase Letter missing";
        }
      } else {
        return "An UPPERCASE letter is a must";
      }
    } else {
      return "Password is too short min (6)";
    }
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;

    final RegExp phoneExp = new RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');

    if (!phoneExp.hasMatch(value))
      return '  (###)  ###-#### - Enter Your phone number.';

    return null;
  }

  bool validPassword(String password) {
    password = password.trim();
    password = password.replaceAll(" ", "");
    RegExp regExp = new RegExp(".*[A-Z]+.*");
    RegExp regExp1 = new RegExp(".*[a-z]+.*");
    RegExp regExp2 = new RegExp(".*[0-9]+.*");
    // userDetails.add(new ArrayList<String>());
    int T = 0, F = 0;

    if (password.length >= 8) {
      if (regExp.allMatches(password).isNotEmpty) {
        print(regExp.allMatches(password));
        if (regExp1.allMatches(password).isNotEmpty) {
          if (regExp2.allMatches(password).isNotEmpty) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Locale myLocale;
  final Set<String> _materials = new Set<String>();

  void _reset() {
    _materials.clear();

    _materials.addAll(_interests);
    _selectedMaterial = '';

    _selectedAction = '';
    _selectedTools.clear();
  }

  void _removeTool(String name) {
    _materials.remove(name);

    _selectedTools.remove(name);
  }

  String UID = '';
  DatabaseReference reference;

  @override
  void initState() {
    super.initState();
    userInfo = Register("", "", "", "", "", new DateTime.now(), "", 0, "", []);
    Fauth = FirebaseAuth.instance;

    ///  UID=Fauth.currentUser().toString();
    reference = FirebaseDatabase.instance.reference();
    reference.child("User_Information").onChildAdded.listen(_onEntryAdded2);
    print(reference.path);
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMMd('en_ISO');
    //myLocale=Localizations.localeOf(context);
    // _controller.addListener(onChange);
    initPlatformState();

    /*_locationSubscription =
      _location.onLocationChanged.listen((Map<String,double> result) {
        setState(() {
          _currentLocation = result;
          print(_currentLocation);
        });
      });*/

    _sncontroller.addListener(s_onChange);
    _fncontroller.addListener(s_onChange);

    _reset();
    _values.addAll([
      'Afghanistan: 93',
      'Albania: 355',
      'Algeria: 213',
      'Andorra: 376',
      'Anguila: 1-264',
      'Antarctica: 672',
      'Antigua: 1-268',
      'Barbuda: 1-268',
      'Argentina: 54',
      'Armenia: 374',
      'Aruba: 297',
      'Australia: 61',
      'Austria: 43',
      'Azerbaijan: 994',
      'Bahamas: 1-242',
      'Bahrain: 973',
      'Bangladesh: 880',
      'Barbados: 1-246',
      'Barbuda: 1-268',
      'Belarus: 375',
      'Belgium: 32',
      'Belize: 501',
      'Benin: 229',
      'Bermuda: 1-441',
      'Bhutan: 975',
      'Boliva: 591',
      'Bosnia: 387',
      'Botswana: 267',
      'Brazil: 55',
      'BIOT: 246',
      'BVI: 1-284',
      'Brunei: 673',
      'Bulgaria: 359',
      'Burkina: 226',
      'Burundi: 257',
      'Columbia: 855',
      'Cameroon: 237',
      'Canada: 1',
      'Cape Verde: 238',
      'Cayman Islands: 1-348',
      'Central African Rep: 236',
      'Chad: 235',
      'Chile: 56',
      'China: 86',
      'Christmas Island: 61',
      'Cocos Islands: 61',
      'Colombia: 57',
      'Comoros: 269',
      'Cook Islands: 682',
      'Costa Rica: 506',
      'Crotia: 385',
      'Cuba: 53',
      'Curacao: 599',
      'Cyprus: 357',
      'Czech Republic: 420',
      'Denmark: 45',
      'Djibouti: 253',
      'Dominica: 1-767',
      'Dominican Republic: 1-809',
      'Dominican Republic: 1-829',
      'Dominican Republic: 1-849',
      'East Timor: 670',
      'Ecuador: 593',
      'Egypt: 20',
      'El Salvador: 503',
      'Equatorial Guinea: 240',
      'Eritrea: 291',
      'Ethiopia: 251',
      'Falkland Islands: 500',
      'Faroe Islands: 298',
      'Fiji: 679',
      'Finland: 358',
      'France: 33',
      'French Polynesia: 689',
      'Gabon: 241',
      'Gambia: 220',
      'Georgia: 995',
      'Germany: 49',
      'Ghana: 233',
      'Gibraltar: 350',
      'Greece: 30',
      'Greenland: 299',
      'Grenada: 1-473',
      'Guam: 1-671',
      'Guatemala: 502',
      'Guernsey: 44-1481',
      'Guinea: 224',
      'Guinea-Bissau: 245',
      'Guyana: 592',
      'Haiti: 509',
      'Herzegonia: 387',
      'Honduras: 504',
      'Hong Kong: 852',
      'Hungary: 36',
      'Iceland: 354',
      'India: 91',
      'Indonesia: 62',
      'Iran: 98',
      'Iraq: 964',
      'Ireland: 353',
      'Isle of Man: 44-1624',
      'Israel: 972',
      'Italy: 39',
      'Ivory Coast: 225',
      'Jamaica: 1-876',
      'Japan: 81',
      'Jersey: 44-1534',
      'Jordan: 962',
      'Kazakhstan: 7',
      'Kenya: 254',
      'Kiribati: 686',
      'Kosovo: 383',
      'Kuwait: 965',
      'Kyrgyzstan: 996',
      'Laos: 856',
      'Latvia: 371',
      'Lebanon: 961',
      'Lesotho: 266',
      'Liberia: 231',
      'Libya: 218',
      'Liechtenstein: 423',
      'Lithuania: 370',
      'Luxembourg: 352',
      'Macau: 853',
      'Macedonia: 389',
      'Madascar: 261',
      'Malawi: 265',
      'Malaysia: 60',
      'Maldives: 960',
      'Mali: 223',
      'Malta: 356',
      'Marshall Islands: 692',
      'Mauritius: 230',
      'Mayotte: 262',
      'Mexico: 52',
      'Micronesia: 691',
      'Moldowa: 373',
      'Monaco: 377',
      'Mongolia: 976',
      'Montenegro: 382',
      'Monsterrat: 1-664',
      'Morocco: 212',
      'Mozambique: 258',
      'Myanmar: 95',
      'Namibia: 264',
      'Nauru: 674',
      'Nepal: 977',
      'Netherlands: 31',
      'Netherlands Antilles: 599',
      'New Caledonia: 687',
      'New Guinea: 675',
      'New Zealand: 64',
      'Nicaragua:505',
      'Niger: 227',
      'Nigeria: 234',
      'Niue: 683',
      'North Korea: 850',
      'N Mariana Islands: 1-670',
      'Norway: 47',
      'Oman: 968',
      'Pakistan: 92',
      'Palau: 680',
      'Palestine: 970',
      'Panama: 507',
      'Paraguay: 595',
      'Peru: 51',
      'Philippines: 63',
      'Pitcairn: 64',
      'Poland: 48',
      'Portugal: 351',
      'Puerto Rico: 1-787',
      'Puerto Rico: 1-939',
      'Qatar: 974',
      'Republic of Congo: 243',
      'Reunion: 262',
      'Romania: 40',
      'Russia: 7',
      'Rwanda: 250',
      'Saint Barthelemy: 590',
      'Saint Helena: 290',
      'Saint K.N: 1-869',
      'Saint Lucia: 1-758',
      'Saint Martin: 590',
      'Saint P.M: 508',
      'Saint Vincent: 1-784',
      'Samoa: 685',
      'San Marino: 378',
      'Sao Tome and Principe: 239',
      'Saudi Arabia: 966',
      'Senegal: 221',
      'Serbia: 381',
      'Seychelles: 248',
      'Sierra Leone: 232',
      'Singapore: 65',
      'Sint Maarten: 1-721',
      'Slovakia: 421',
      'Slovenia: 386',
      'Solomon Islands: 677',
      'Somalia: 252',
      'South Africa: 27',
      'South Korea: 82',
      'South Sudan: 211',
      'Spain: 34',
      'Sri lanka: 94',
      'Sudan: 249',
      'Suriname: 579',
      'Svalbard and Jan Mayen: 47',
      'Swaziland: 268',
      'Sweden: 46',
      'Switzerland: 41',
      'Syria: 963',
      'Taiwan: 886',
      'Tajikistan: 992',
      'Tanzania: 255',
      'Thailand: 66',
      'Togo: 228',
      'Tokelau: 690',
      'Tonga: 676',
      'Trinidad and Tobago: 1-868',
      'Tunisia: 216',
      'Turkey: 90',
      'Turkmenistan: 993',
      'TCA: 1-649',
      'Tuvalu: 688',
      'U.S Virgin Islands: 1-340',
      'Uganda: 256',
      'Ukraine: 380',
      'United Arab Emirates: 971',
      'UK: 44',
      'USA: 1',
      'Uruguay: 598',
      'Uzbekistan: 998',
      'Vanuatu: 678',
      'Vatican: 379',
      'Venezuela: 58',
      'Vietnam: 84',
      'Wallis and Futuna: 681',
      'Western Sahara: 212',
      'Yemen: 967',
      'Zambia: 260',
      'Zimbabwe: 263'
    ]);

    divideValues();

    _value = _values.elementAt(0);

    //_textFocus.addListener(onChange);
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
      _value2 = _MCC.elementAt(_values.lastIndexOf(value));
    });
  }

  String acceptName() {
    return new UsernameGenerator().getUsername();
  }

  bool isOneCompleted = false;

  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  int current_step = 0;

  List<Step> my_steps;

  bool _autovalidate = false;
  int _tapped = 0;
  bool _formWasEdited = false;

  // List<DropdownMenuItem> locations = [new Drop];

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  bool isUserExisting(String user) {
    bool doesExists = false;
    for (Register users in userInfos) {
      print(users.email.toLowerCase() == user.toLowerCase());
      if (users.username.toLowerCase() == user.toLowerCase() ||
          users.email.toLowerCase() == user.toLowerCase()) return false;
    }
    return true;
  }

  _sendMail() {
    print("Userneame: $email Pass: $password");

    userInfo = new Register(
        username,
        email,
        fn,
        sn,
        new DateFormat.yMd('en_ISO').format(birthday),
        new DateTime.now(),
        sex,
        num.tryParse(phone_no),
        _image.path,
        _interests);
    saveUserInformation();
  }

  _goHome() {
    userInfo = new Register(
        username,
        email,
        fn,
        sn,
        new DateFormat.yMd('en_ISO').format(birthday),
        new DateTime.now(),
        sex,
        num.tryParse(phone_no),
        _image.path,
        _interests);
    saveUserInformation();
    Navigator.of(context).pushNamed("/Home");
  }

  _sendSMS() {}

  sendEmail() {
    register = new Register(
        username,
        email,
        fn,
        sn,
        birthday.toString(),
        new DateTime.now(),
        sex,
        num.tryParse(phone_no),
        _image != null ? _image.path : '',
        _interests);
    print(register);
    _showAlertDialog('');
  }

  Future<Null> _showAlertDialog(String value) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        print('showing....');
        return new AlertDialog(
          content: new Center(
            child: new Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ProfileImage(defaultImages, true,
                        initials: userInitials,
                        image: _image != null
                            ? new FileImage(_image)
                            : new AssetImage('images/hbot_wave.png'),
                        width: 100.0,
                        height: 100.0,
                        color: Colors.midnightAccent,
                        shape: BoxShape.circle,
                        fill: Colors.midnightAccent),
                    new Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage('images/ic_launcher.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: const EdgeInsets.only(top: 35.0)),
                new Text('Congrats $fn,  We\'re Glad that You Joined us.',
                    style: new TextStyle(
                      fontFamily: 'Jua',
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                onPressed: _sendMail,
                child: new Text(
                  'Gimme a Tour',
                  style: new TextStyle(color: Colors.blue),
                )),
            // new FlatButton(onPressed: _sendSMS, child: new Text('Send SMS',style: new TextStyle(color: Colors.blue),)),
            new FlatButton(
                onPressed: _goHome,
                child: new Text(
                  'Take me Home',
                  style: new TextStyle(color: Colors.green),
                )),
          ],
        );
      },
    );
  }

  String _capitalize(String name) {
    assert(name != null && name.isNotEmpty);
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  /*Locale myLocale = Localizations.localeOf(context);
    print(myLocale.countryCode);*/
  String _selectedMaterial = '';
  String _selectedAction = '';
  final Set<String> _selectedTools = new Set<String>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> choiceChips = _materials.map<Widget>((String name) {
      return new FilterChip(
        key: new ValueKey<String>(name),
        backgroundColor: _nameToColor(name),
        label: new Text(_capitalize(name)),
        selected:
            _materials.contains(name) ? _selectedTools.contains(name) : false,
        onSelected: !_materials.contains(name)
            ? null
            : (bool value) {
                setState(() {
                  if (!value) {
                    _selectedTools.remove(name);
                  } else {
                    _selectedTools.add(name);
                  }
                  if (_selectedTools.isNotEmpty) {
                    isSixCompleted = true;
                  }
                });
              },
      );
    }).toList();

    snackbar = SnackBar(
      duration: new Duration(seconds: 5),
      content: Text('This email is Linked to an Account'),
      action: SnackBarAction(
        label: 'Login',
        onPressed: () {
          Navigator.of(context).pushNamed("/Login");
          // Some code to undo the change!
          /*  Navigator.push(context, new PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return new Center(child: new Text('My PageRoute'));
              },
              transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                return new FadeTransition(
                  opacity: animation,
                  child: new RotationTransition(
                    turns: new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                    child: child,
                  ),
                );
              }
          ));*/
        },
      ),
    );
    // Scaffold.of(context).showSnackBar(snackbar);

    my_steps = [
      new Step(

          // Title of the Step

          title: new Text(
            isOneCompleted ? "Registered *" : "Register *",
            style: new TextStyle(
              color: isOneCompleted
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),

          // Content, it can be any widget here. Using basic Text for this example

          content: new Form(
            key: formkey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 24.0,
                ),
                new TextFormField(
                  controller: _ucontroller,
                  validator: (value) => _isValidUser(value),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14.0, fontFamily: 'Jua'),
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    icon: const Icon(Icons.person,
                        color: Colors.midnightTextPrimary),
                    hintText: 'Enter Username..',
                    hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                        fontFamily: 'Jua'),
                    labelText: 'Username',
                    labelStyle: TextStyle(
                        color: Colors.midnightTextPrimary,
                        fontSize: 14.0,
                        fontFamily: 'ExoLight'),
                    suffixIcon: new GestureDetector(
                      onTap: () {
                        generateName();
                        setState(() {
                          _ucontroller.text = generatedUsername;
                          username = _ucontroller.text;
                        });
                      },
                      child: new Icon(
                        Icons.assignment_ind,
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                  ),
                ),
                new Padding(padding: const EdgeInsets.only(top: 12.0)),
                new TextFormField(
                  controller: _econtroller,
                  validator: (value) => _isValidEmail(value),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14.0, fontFamily: 'Jua'),
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: new Icon(Icons.email,
                          color: _validEmail
                              ? Colors.lightGreenAccent
                              : Colors.midnightTextPrimary),
                      hintText: 'Enter Email..',
                      hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                          fontFamily: 'Jua'),
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                          color: Colors.midnightTextPrimary,
                          fontSize: 14.0,
                          fontFamily: 'ExoLight')),
                ),
                new Padding(padding: const EdgeInsets.only(top: 12.0)),
                new TextFormField(
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'sans-serif'),
                  obscureText: _obscureText,
                  validator: (value) => isValidPassword(value),
                  controller: _controller,
                  decoration: new InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: false,
                    icon: _validPassword
                        ? const Icon(Icons.lock_open, color: Colors.green)
                        : const Icon(Icons.lock,
                            color: Colors.midnightTextPrimary),
                    hintText: 'Enter Password',
                    labelText: "Password",
                    hintStyle: new TextStyle(
                        fontFamily: 'Jua',
                        color: Colors.white30,
                        fontSize: 18.0),
                    labelStyle: new TextStyle(
                        fontFamily: 'Jua', color: Colors.midnightTextPrimary),
                    suffixIcon: new GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: new Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.midnightAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          state: isOneCompleted ? StepState.complete : StepState.error,
          isActive: true),
      new Step(
          title: new Text(
            isTwoCompleted ? fn + " " + sn + " *" : "Full-Name *",
            style: new TextStyle(
              color: isTwoCompleted
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: new Form(
            key: formkey2,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 24.0,
                ),
                new TextFormField(
                  controller: _fncontroller,
                  validator: (value) => __isValidName(value),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14.0, fontFamily: 'Jua'),
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      icon: new Icon(Icons.perm_identity,
                          color: Colors.midnightTextPrimary),
                      hintText: 'Enter First name..',
                      hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                          fontFamily: 'Jua'),
                      labelText: 'First name',
                      labelStyle: const TextStyle(
                          color: Colors.midnightTextPrimary,
                          fontSize: 18.0,
                          fontFamily: 'Jua')),
                ),
                new Padding(padding: const EdgeInsets.only(top: 12.0)),
                new TextFormField(
                  controller: _sncontroller,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14.0, fontFamily: 'Jua'),
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: 'Enter Last name..',
                      hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                          fontFamily: 'Jua'),
                      labelText: 'Last name',
                      labelStyle: const TextStyle(
                          color: Colors.midnightTextPrimary,
                          fontSize: 18.0,
                          fontFamily: 'Jua')),
                ),
              ],
            ),
          ),

          // You can change the style of the step icon i.e number, editing, etc.

          state: isTwoCompleted ? StepState.complete : StepState.error,
          isActive: true),
      new Step(
          title: new Text(
            isThreeCompleted
                ? 'DOB: ' +
                    new DateFormat.yMd('en_ISO').format(_fromDate) +
                    ' (${new DateTime.now().year - _fromDate.year})'
                : "Birthday *",
            style: new TextStyle(
              color: isThreeCompleted
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: new Column(
            children: <Widget>[
              new DatePicker(
                labelText: 'When\'s Your B-Day',
                selectedDate: _fromDate,
                labelStyle: new TextStyle(
                    color: Colors.midnightTextPrimary,
                    fontSize: 18.0,
                    fontFamily: 'Jua'),
                labelStyle2: new TextStyle(
                    color: Colors.white, fontSize: 14.0, fontFamily: 'Jua'),
                valueStyle: new TextStyle(
                    color: Colors.midnightTextPrimary,
                    fontSize: 14.0,
                    fontFamily: 'Jua'),
                selectDate: (DateTime date) {
                  setState(() {
                    _fromDate = date;
                  });
                  if (isValidBirthday()) {
                    setState(() {
                      isThreeCompleted = true;
                      ageError = new Text('');
                    });
                  } else {
                    setState(() {
                      isThreeCompleted = false;
                      ageError = new Text(
                          'Oops Sorry! You must be 6 or over to have an account',
                          style: new TextStyle(
                              color: Colors.red,
                              fontFamily: 'Jua',
                              fontSize: 16.0));
                    });
                  }
                },
              ),
              ageError
            ],
          ),
          state: isThreeCompleted ? StepState.complete : StepState.error,
          isActive: true),
      new Step(
          title: new Text(
            isFourCompleted ? "Gender: $sex" : "Gender: Male *",
            style: new TextStyle(
              color: isFourCompleted
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: new Column(
            children: <Widget>[
              new Icon(Icons.wc, color: Colors.midnightTextPrimary),
              new Padding(padding: const EdgeInsets.only(left: 6.0)),
              new Text(
                'Select Gender',
                style: new TextStyle(
                    color: Colors.midnightTextPrimary,
                    fontFamily: 'Jua',
                    fontSize: 16.0),
              ),
              new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                new Row(children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(
                        '\u2642',
                        style: new TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jua'),
                      ),
                      new Text(
                        'Male',
                        style: new TextStyle(
                            color: Colors.midnightTextPrimary,
                            fontSize: 14.0,
                            fontFamily: 'Jua'),
                      ),
                    ],
                  ),
                  new Radio<int>(
                      value: 0,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged)
                ]),
                new Row(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Text(
                          '\u2640',
                          style: new TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Jua'),
                        ),
                        new Text(
                          'Female',
                          style: new TextStyle(
                              color: Colors.midnightTextPrimary,
                              fontSize: 14.0,
                              fontFamily: 'Jua'),
                        ),
                      ],
                    ),
                    new Radio<int>(
                        value: 1,
                        groupValue: radioValue,
                        activeColor: Colors.pinkAccent,
                        onChanged: handleRadioValueChanged),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      'Other',
                      style: new TextStyle(
                          color: Colors.midnightTextPrimary,
                          fontSize: 14.0,
                          fontFamily: 'Jua'),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Radio<int>(
                        value: 2,
                        groupValue: radioValue,
                        activeColor: Colors.deepPurpleAccent,
                        onChanged: handleRadioValueChanged),
                  ],
                ),
              ]),
            ],
          ),
          state: StepState.complete,
          isActive: true),
      new Step(
          title: new Text(
            isFiveCompleted ? phone_no : "Phone Number: Not Provided",
            style: new TextStyle(
              color: isFiveCompleted
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: new Column(
            children: <Widget>[
              new DropdownButton(
                  value: _value,
                  items: _values.map((String value) {
                    return new DropdownMenuItem(
                      value: value,
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Icon(
                            Icons.assistant_photo,
                            color: Colors.blue,
                          ),
                          Text("${value}",
                              style: new TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 14.0,
                                  fontFamily: 'Jua')),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    _onChanged(value);
                  }),
              new TextFormField(
                controller: _phoneController,
                validator: (value) => _validPhoneNumber(value),
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontFamily: 'Jua',
                ),

                decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: false,

                    // icon: const Icon(Icons.phone,color: Colors.midnightTextPrimary),

                    labelText: 'Phone Number',
                    labelStyle: new TextStyle(
                        color: Colors.midnightTextPrimary,
                        fontSize: 14.0,
                        fontFamily: 'Jua'),
                    prefixText: '+ ${_value2} ',
                    prefixStyle: new TextStyle(
                        color: Colors.midnightTextPrimary,
                        fontFamily: 'Jua',
                        fontSize: 16.0)),

                keyboardType: TextInputType.phone,

                // onSaved: (String value) { person.phoneNumber = value; },

                // TextInputFormatters are applied in sequence.

                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,

                  // Fit the validating format.

                  _phoneNumberFormatter,
                ],
              ),
            ],
          ),
          state: isFourCompleted ? StepState.complete : StepState.indexed,
          isActive: true),
      new Step(
          title: new Text(
            isSixCompleted
                ? "Interests: ${_selectedTools.length} Selected"
                : "Interests: None Selected",
            style: new TextStyle(
              color: isSixCompleted
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: new Column(
            children: <Widget>[
              new Icon(Icons.touch_app, color: Colors.midnightTextPrimary),
              new Padding(padding: const EdgeInsets.only(left: 6.0)),
              new Text(
                'Select your interests',
                style: new TextStyle(
                    color: Colors.midnightTextPrimary,
                    fontFamily: 'Jua',
                    fontSize: 16.0),
              ),
              new ChipTile(label: '', children: choiceChips),
            ],
          ),
          state: isSixCompleted ? StepState.complete : StepState.editing,
          isActive: true),
      new Step(
          title: new Text(
            "Profile Pic",
            style: new TextStyle(
              color: isSevenCompleted
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new ProfileImage(
                defaultImages,
                false,
                initials: userInitials,
                image: _image != null
                    ? new FileImage(_image)
                    : new AssetImage('images/hbot_wave.png'),
                width: 100.0,
                height: 100.0,
                color: Colors.midnightTextPrimary,
                shape: BoxShape.circle,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new FloatingActionButton(
                        onPressed: getImage,
                        backgroundColor: Colors.purpleAccent,
                        tooltip: 'Pick Image',
                        child: new Icon(Icons.image),
                      ),
                      new Text(
                        'Pick Image',
                        style: new TextStyle(
                            color: Colors.midnightTextPrimary,
                            fontFamily: 'Jua',
                            fontSize: 16.0),
                      )
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new FloatingActionButton(
                        onPressed: takePic,
                        tooltip: 'Take a Pic',
                        child: new Icon(Icons.camera_alt),
                      ),
                      new Text(
                        'Take a Pic',
                        style: new TextStyle(
                            color: Colors.midnightTextPrimary,
                            fontFamily: 'Jua',
                            fontSize: 16.0),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          state: isSixCompleted ? StepState.complete : StepState.editing,
          isActive: true),
      new Step(
          title: new Text(
            "Finalize",
            style: new TextStyle(
              color: isAllComplete
                  ? Colors.lightGreenAccent
                  : Colors.lightBlueAccent,
              fontFamily: 'ExoLight',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: new Container(
            child: new RaisedButton(
              onPressed: isAllComplete ? sendEmail() : null,
              shape: new RoundedRectangleBorder(
                  side: new BorderSide(
                    color: Colors.midnightAccent,
                    width: 2.0,
                  ),
                  borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.green,
              child: new Text(
                isAllComplete
                    ? 'I\'m Happy with everything ☺'
                    : 'Oops you\'re not Done',
                style: new TextStyle(
                    color: isAllComplete ? Colors.white70 : Colors.red,
                    fontSize: 14.0,
                    fontFamily: 'Jua'),
              ),
            ),
          ),
          state: isAllComplete ? StepState.complete : StepState.editing,
          isActive: true),
    ];

    return new Form(
      key: mainformkey,

      autovalidate: _autovalidate,

      //onWillPop: _warnUserAboutInvalidData,

      child: new Flexible(
        child: new Stepper(
          // Using a variable here for handling the currentStep

          currentStep: this.current_step,

          // List the steps you would like to have

          steps: my_steps,

          // Define the type of Stepper style

          // StepperType.horizontal :  Horizontal Style

          // StepperType.vertical   :  Vertical Style

          type: StepperType.vertical,

          // Know the step that is tapped

          onStepTapped: (step) {
            // On hitting step itself, change the state and jump to that step
            if (step == 0)
              SaveAndValidate();
            else if (step == 1) SaveAndValidate2();
            setState(() {
              // update the variable handling the current step value

              // jump to the tapped step

              setState(() {
                isFiveCompleted = true;
              });
              current_step = step;
              print("OnStepped: $current_step");
              if (step == 0)
                SaveAndValidate();
              else if (step == 1) {
                SaveAndValidate2();
              } else if (step == 4) {
                phone_no = _phoneController.text;
                if (_validPhoneNum()) {
                } else {
                  setState(() {
                    isFiveCompleted = false;
                  });
                }
              } else if (step == 5) {
                isSevenCompleted = true;
              } else if (step == 6) {
                email = _econtroller.text;
                username = _ucontroller.text;
                password = _controller.text;
                fn = _fncontroller.text;
                sn = _sncontroller.text;
                birthday = _fromDate;
                phone_no = phone_no;
                String interests;

                for (String s in _selectedTools) {
                  interests += s + "\n";
                }

                print(
                    "Username: $username\nEmail: $email\nPassword: $password\nFirst name: $fn\nSecond name: $sn\nGender: $sex\nPhone no.: $phone_no\nInterest: ${interests}");
              } else if (step == 7) {
                if (isOneCompleted &&
                    isTwoCompleted &&
                    isThreeCompleted &&
                    isFourCompleted) isAllComplete = true;
                saveAuth(password, email);
              }
            });

            // Log function call

            print("onStepTapped : " + step.toString());
          },

          onStepCancel: () {
            // On hitting cancel button, change the state

            setState(() {
              // update the variable handling the current step value

              // going back one step i.e subtracting 1, until its 0

              if (current_step > 0) {
                current_step = current_step - 1;
              } else {
                current_step = 0;
              }
            });

            // Log function call

            print("onStepCancel : " + current_step.toString());
          },

          // On hitting continue button, change the state

          onStepContinue: () {
            setState(() {
              // update the variable handling the current step value

              // going back one step i.e adding 1, until its the length of the step

              if (current_step < my_steps.length - 1) {
                current_step = current_step + 1;
              } else {
                if (isOneCompleted &&
                    isTwoCompleted &&
                    isThreeCompleted &&
                    isFourCompleted) isAllComplete = true;
                sendEmail();
              }
              var step = current_step;
              print("Oncontinued: $step");
              if (step == 1)
                SaveAndValidate();
              else if (step == 2)
                SaveAndValidate2();
              else if (step == 4) {
                email = _econtroller.text;
                username = _ucontroller.text;
                password = _controller
                    .text; //.replaceRange(1, _controller.text.length, '*');
                fn = _fncontroller.text;
                sn = _sncontroller.text;
                birthday = _fromDate;
                phone_no = phone_no;
              } else if (step == 3) {
                email = _econtroller.text;
                username = _ucontroller.text;
                password = _controller
                    .text; //.replaceRange(1, _controller.text.length, '*');
                fn = _fncontroller.text;
                sn = _sncontroller.text;
                birthday = _fromDate;
                phone_no = phone_no;
              } else if (step == 5) {
                email = _econtroller.text;
                username = _ucontroller.text;
                password = _controller
                    .text; //.replaceRange(1, _controller.text.length, '*');
                fn = _fncontroller.text;
                sn = _sncontroller.text;
                birthday = _fromDate;
                phone_no = phone_no;
                phone_no = _phoneController.text;
                if (_validPhoneNum()) {
                  setState(() {
                    isFiveCompleted = true;
                  });
                } else {
                  setState(() {
                    isFiveCompleted = false;
                  });
                }
              } else if (step == 6) {
                email = _econtroller.text;
                username = _ucontroller.text;
                password = _controller
                    .text; //.replaceRange(1, _controller.text.length, '*');
                fn = _fncontroller.text;
                sn = _sncontroller.text;
                birthday = _fromDate;
                phone_no = phone_no;
                isSevenCompleted = true;
              } else if (step == 7) {
                email = _econtroller.text;
                username = _ucontroller.text;
                password = _controller
                    .text; //.replaceRange(1, _controller.text.length, '*');
                fn = _fncontroller.text;
                sn = _sncontroller.text;
                birthday = _fromDate;
                phone_no = phone_no;
                if (isOneCompleted &&
                    isTwoCompleted &&
                    isThreeCompleted &&
                    isFourCompleted) isAllComplete = true;
                saveAuth(password, email);
                sendEmail();
              }
            });

            // Log function call

            print("onStepContinue : " + current_step.toString());
          },
        ),
      ),
    );
  }

  static String _validatePassword(String value) {}

  void seePassword() {
    setState(() {});
  }

  void onChange() {
    _ucontroller.text = username;
    print(isValidPassword(_controller.text));
  }

  void s_onChange() {
    setState(() {
      fn = _fncontroller.text;
      sn = _sncontroller.text;
    });
  }

  String _validPhoneNumber(String value) {
    if (value.length < 5) {
      return 'This Phone Number is Invalid';
    } else
      return null;
  }

  bool _validPhoneNum() {
    if (phone_no.length < 5) {
      return false;
    } else
      return true;
  }
}

class UsernameGenerator {
  String createUsername() {
    String pattern = '[A-Za-z]+';
  }

  bool searchForVowels(String word) {
    word = word.toLowerCase();
    int found = 0;
    var vowels = ['a', 'e', 'i', 'o', 'u'];
    for (String v in vowels) {
      for (int i = 0; i < word.length - 1; i++) {
        if (word.substring(i, i + 1) == v) {
          found++;
        }
      }
    }

    if (found >= 1)
      return true;
    else
      return false;
  }

  String getUsername() {
    String username = "";
    username = username.toLowerCase();
    var alphabets = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    ];
    int alphapick = 0;
    int generatedLength = 0;
    while (!(searchForVowels(username) &&
        (searchForConsonants(username)) &&
        checkWordEfficiency(username))) {
      generatedLength = rndNumber(2, 5);
      username = "";
      for (int i = 0; i < generatedLength; i++) {
        alphapick = rndNumber(0, alphabets.length - 1);

        username += alphabets[alphapick];
      }
      print("Username: $username");
    }
    return insertNumber(username);
  }

  String insertNumber(String name) {
    int pos = rndNumber(0, name.length - 1);
    int randNumber = rndNumber(0, 20000);
    String finalUsername = name;
    if (randNumber < 60) {
      finalUsername =
          finalUsername.replaceRange(pos, pos + 1, randNumber.toString());
    } else {
      finalUsername += randNumber.toString();
    }
    String username = finalUsername;
    print("username $randNumber");
    username =
        username.replaceRange(0, 1, username.substring(0, 1).toUpperCase());
    return username;
  }

  String charAt(String word, int index) {
    word += "a";
    return word.substring(index, index + 1);
  }

  bool checkWordEfficiency(String word) {
    int efficent = 0;
    String vowels = "a|e|i|o|u"; // not r'/api/\w+/\d+/' !!!
    String consonants = "b|c|d|f|g|h|j|k|l|m|n|p|q|r|s|t|v|w|x|y|z";
    for (int i = 0; i < word.length; i++) {
      for (int j = 0; j < word.length; j++) {
        if (charAt(word, i).contains(vowels)) {
          if (charAt(word, j) == charAt(word, i)) {
            efficent -= 10;
          } else if (searchForVowels(charAt(word, j))) {
            efficent -= 50;
          } else
            efficent += 50;
        } else {
          if (charAt(word, j) == charAt(word, i)) {
            efficent -= 10;
          } else if (searchForConsonants(charAt(word, j))) {
            efficent -= 50;
          } else
            efficent += 50;
        }
      }
    }
    print("Effieciency: " + efficent.toString() + "%");
    if (efficent <= 100)
      return false;
    else
      return true;
  }

  num rndNumber(num min, num max) {
    return new Random().nextInt(max - min + 1) + min;
  }

  bool searchForConsonants(String word) {
    word = word.toLowerCase();
    int found = 0;
    var cons = [
      'b',
      'c',
      'd',
      'f',
      'g',
      'h',
      'j',
      'k',
      'l',
      'm',
      'n',
      'p',
      'q',
      'r',
      's',
      't',
      'v',
      'w',
      'x',
      'y',
      'z'
    ];
    for (String c in cons) {
      for (int i = 0; i < word.length - 1; i++) {
        if (word.substring(i, i + 1) == c) {
          found++;
        }
      }
    }

    if (found >= 1)
      return true;
    else
      return false;
  }
}

class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;

    int selectionIndex = newValue.selection.end;

    int usedSubstringIndex = 0;

    final StringBuffer newText = new StringBuffer();

    if (newTextLength >= 1) {
      newText.write('(');

      if (newValue.selection.end >= 1) selectionIndex++;
    }

    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');

      if (newValue.selection.end >= 3) selectionIndex += 2;
    }

    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');

      if (newValue.selection.end >= 6) selectionIndex++;
    }

    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');

      if (newValue.selection.end >= 10) selectionIndex++;
    }

    // Dump the rest.

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));

    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class UIDs {
  var _uid;

  UIDs(this._uid);

  String get uid => _uid;

  set uid(dynamic value) {
    _uid = value;
  }

  UIDs.fromSnapshot(DataSnapshot snapshot) : _uid = snapshot.key;
}
