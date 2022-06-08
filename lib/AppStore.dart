import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

typedef ViewModelBuilder<AppStore> = Widget Function(
    BuildContext context,
    AppStore store,
    );

class AppStore {
  static Store<AppStore> store = Store(
        (AppStore state, dynamic action) => state,
    initialState: AppStore(),
  );

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
    store.dispatch(null);
  }
  StoreConnector connect(ViewModelBuilder<AppStore> builder){
    return StoreConnector<AppStore, AppStore>(
      converter: (store) => store.state,
      builder: builder,
    );
  }
}