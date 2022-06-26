import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'AppStoreData.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uuid/uuid.dart';

class AppStore{

  static String host = "http://jamsys.ru:8081/";
  static String personKey = const Uuid().v4();
  static final AppStore _singleton = AppStore._internal();

  factory AppStore() {
    return _singleton;
  }

  AppStore._internal();

  static Store<AppStore> store = Store(
        (AppStore state, dynamic action) => state,
    initialState: AppStore(),
  );

  static AppStoreData? getStore(BuildContext context, String? name, {bool syncSocket = false}){
    if(name == null || name == ""){
      return null;
    }
    return StoreProvider.of<AppStore>(context).state.get(context, name, {syncSocket: syncSocket});
  }

  static AppStoreData? getStoreByName(BuildContext context, String name){
    return StoreProvider.of<AppStore>(context).state.getByName(name);
  }

  static dynamic connect(String dataUID, Widget Function(AppStoreData? store, dynamic defaultValue) builder, {syncSocket = false, defaultValue = ""}){
    AppStoreData? byName = store.state.getByName(dataUID);
    if(byName != null){
      return StoreConnector<AppStore, AppStoreData>(
        converter: (store) => store.state.getByName(dataUID)!,
        builder: (context, state){
          return Function.apply(builder, [state, defaultValue]);
        },
      );
    }else{
      return Function.apply(builder, [null, defaultValue]);
    }
  }

  final Map<BuildContext, AppStoreData> _map = {};

  AppStoreData? get(BuildContext key, String? name, Map map, {bool syncSocket = false }) {
    if(name != null && name != "" && _map[key] == null){
      _map[key] = AppStoreData(AppStore.store, name);
      return _map[key];
    }
    if(_map[key] != null){
      return _map[key];
    }
    return null;
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