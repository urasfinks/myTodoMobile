import 'package:redux/redux.dart';

class AppStoreData {
  AppStoreData(this.store, this.name);

  final Store store;
  final String name;
  final Map<String, dynamic> _map = {};

  dynamic get(String key, dynamic defValue) {
    if (_map[key] == null) {
      _map[key] = defValue;
    }
    return _map[key];
  }

  void set(String key, dynamic value) {
    _map[key] = value;
  }

  void inc(String key, {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0}) {
    _map[key] = double.parse("${_map[key]}") + step;
    if(_map[key] < min){
      _map[key] = min;
    }
    if(_map[key] > max){
      _map[key] = max;
    }
    _map[key] = (_map[key]).toStringAsFixed(fixed);
  }

  void dec(String key, {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0}) {
    _map[key] = double.parse("${_map[key]}") - step;
    if(_map[key] < min){
      _map[key] = min;
    }
    if(_map[key] > max){
      _map[key] = max;
    }
    _map[key] = (_map[key]).toStringAsFixed(fixed);
  }

  void toggle(String key){
    String x = "${_map[key]}".toLowerCase();
    if(x == "true" || x == "1"){
      _map[key] = true;
    }else{
      _map[key] = false;
    }
  }

  void apply() {
    store.dispatch(null);
  }

}