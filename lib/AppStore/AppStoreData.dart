import '../WebSocket.dart';

import 'package:redux/redux.dart';

class AppStoreData {
  AppStoreData(this.store, this.name);

  final Store store;
  final String name;
  final Map<String, dynamic> _map = {};
  int _indexRevision = 0;

  void Function()? _onIndexRevisionError;

  void setOnIndexRevisionError(void Function()? fn) {
    _onIndexRevisionError = fn;
  }

  void onIndexRevisionError(){
    if (_onIndexRevisionError != null) {
      Function.apply(_onIndexRevisionError!, []);
    }
  }

  void setIndexRevision(int newValue, {bool checkSequence = true}) {
    if(checkSequence == true){
      if (_indexRevision == newValue - 1) {
        _indexRevision++;
      } else {
        onIndexRevisionError();
      }
    }else{
      _indexRevision = newValue;
    }
  }

  dynamic get(String key, dynamic defValue) {
    if (_map[key] == null) {
      _map[key] = defValue;
    }
    return _map[key];
  }

  void set(String key, dynamic value, {bool notify = true}) {
    _map[key] = value;
    if (notify == true) {
      onChange(key);
    }
  }

  void inc(String key,
      {double step = 1.0,
      double min = -999.0,
      double max = 999.0,
      int fixed = 0,
      bool notify = true}) {
    _map[key] = double.parse("${_map[key]}") + step;
    if (_map[key] < min) {
      _map[key] = min;
    }
    if (_map[key] > max) {
      _map[key] = max;
    }
    _map[key] = (_map[key]).toStringAsFixed(fixed);
    if (notify == true) {
      onChange(key);
    }
  }

  void dec(String key,
      {double step = 1.0,
      double min = -999.0,
      double max = 999.0,
      int fixed = 0,
      bool notify = true}) {
    _map[key] = double.parse("${_map[key]}") - step;
    if (_map[key] < min) {
      _map[key] = min;
    }
    if (_map[key] > max) {
      _map[key] = max;
    }
    _map[key] = (_map[key]).toStringAsFixed(fixed);
    if (notify == true) {
      onChange(key);
    }
  }

  void toggle(String key, {bool notify = true}) {
    String x = "${_map[key]}".toLowerCase();
    if (x == "true" || x == "1") {
      _map[key] = true;
    } else {
      _map[key] = false;
    }
    if (notify == true) {
      onChange(key);
    }
  }

  void onChange(String key) {
    WebSocket()
        .send(name, "update_state", data: {"key": key, "value": _map[key]});
  }

  void apply() {
    store.dispatch(null);
  }

}
