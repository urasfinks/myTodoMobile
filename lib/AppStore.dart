import 'package:flutter/cupertino.dart';

class AppStore with ChangeNotifier {
  Map<String, dynamic> _map = {};

  dynamic get(String key, dynamic defValue) {
    if (_map[key] == null) {
      _map[key] = defValue;
    }
    return _map[key];
  }

  void set(String key, dynamic value) {
    _map[key] = value;
  }

  void inc(String key, {int step = 1}) {
    _map[key] += step;
  }

  void dec(String key, {int step = 1}) {
    _map[key] -= step;
  }

  void apply() {
    //store.dispatch(null);
    notifyListeners();
  }

}