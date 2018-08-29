class Achievements {
  String _id = 'gold';
  int _amount = 123;

  Achievements([this._id, this._amount]);

  int get amount => _amount;

  set amount(int value) {
    _amount = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  @override
  String toString() {
    return 'Achievements{_id: $_id, _amount: $_amount}';
  }
}
