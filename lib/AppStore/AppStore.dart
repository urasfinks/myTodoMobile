import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'AppStoreData.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AppStore{
  static final AppStore _singleton = AppStore._internal();

  factory AppStore() {
    return _singleton;
  }

  AppStore._internal();

  static Store<AppStore> store = Store(
        (AppStore state, dynamic action) => state,
    initialState: AppStore(),
  );

  static AppStoreData getStore(BuildContext context, String name){
    return StoreProvider.of<AppStore>(context).state.get(context, name);
  }

  static AppStoreData? getStoreByName(BuildContext context, String name){
    return StoreProvider.of<AppStore>(context).state.getByName(name);
  }

  static StoreConnector connect(BuildContext context, Widget Function(AppStoreData store) builder){
    return StoreConnector<AppStore, AppStoreData>(
      converter: (store) => store.state.get(context, ""),
      builder: (context, state){
        return Function.apply(builder, [state]);
      },
    );
  }

  final Map<BuildContext, AppStoreData> _map = {};

  dynamic get(BuildContext key, String name) {
    if (_map[key] == null) {
      _map[key] = AppStoreData(AppStore.store, name);
    }
    return _map[key];
  }

  AppStoreData? getByName(String name) {
    for(var item in _map.entries){
      if(item.value.name == name){
        return item.value;
      }
    }
    return null;
  }

}