class Login {
  String _username;
  String _password;
  String _email;

  Login(this._username, this._password, this._email);

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String encyptPassword() {
    Pattern pattern = '*[.]*';
    return _password.replaceAll(pattern, '*');
  }

  @override
  String toString() {
    return 'Login: \nUsername: $_username \nPassword: ${encyptPassword()} \nEmail: $_email';
  }
}
