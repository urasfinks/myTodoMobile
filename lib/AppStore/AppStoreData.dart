import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:test3/DynamicPage/DynamicPage.dart';

import '../WebSocket.dart';

import 'package:redux/redux.dart';

class AppStoreData {

  bool syncSocket;
  final Store store;
  final Map<String, dynamic> _map = {};
  int _indexRevision = 0;

  AppStoreData(this.store, {this.syncSocket = false});

  void setIndexRevisionWithoutReload(int index){
    _indexRevision = index;
  }

  BuildContext? _ctx;
  Map<String, TextEditingController> listController = {};
  State? pageState;

  Map<String, dynamic> widgetData = {};

  String getStringStoreState(){
    if(_map.isNotEmpty){
      return jsonEncode(_map);
    }
    return "";
  }

  void addWidgetDataByMap(Map<String, dynamic> obj){
    for (var item in widgetData.entries) {
      if(obj.containsKey(item.key) && item.key != "dataUID"){ //dataUID final by addWidgetDataByPage
        addWidgetData(item.key, obj[item.key]);
      }
    }
  }

  void addWidgetDataByPage(DynamicPage widget){
    addWidgetData("title", widget.title);
    addWidgetData("root", widget.root);
    addWidgetData("url", widget.url);
    addWidgetData("parentState", widget.parentState);
    addWidgetData("dataUID", widget.dataUID);
    addWidgetData("wrapPage", widget.wrapPage);
    addWidgetData("pullToRefreshBackgroundColor", widget.pullToRefreshBackgroundColor);
    addWidgetData("appBarBackgroundColor", widget.appBarBackgroundColor);
    addWidgetData("backgroundColor", widget.backgroundColor);
    addWidgetData("progressIndicatorBackgroundColor", widget.progressIndicatorBackgroundColor);
    addWidgetData("progressIndicatorColor", widget.progressIndicatorColor);
    addWidgetData("dialog", widget.dialog);
    addWidgetData("separated", widget.separated);
    addWidgetData("dialogHeight", widget.dialogHeight);
  }

  void addWidgetData(String key, dynamic value){
    //print("addWidgetData(${key}) = ${value}");
    widgetData[key] = value;
  }

  Map<String, dynamic> getWidgetDates(){
    return widgetData;
  }

  dynamic getWidgetData(String key){
    return widgetData[key];
  }

  void setPageState(State x){
    pageState = x;
  }

  State? getPageState(){
    return pageState;
  }

  void setCtx(BuildContext value) {
    _ctx = value;
  }

  Map<String, dynamic> serverResponse = {};

  void setServerResponse(Map<String, dynamic> input){
    serverResponse = input;
  }

  Map<String, dynamic> getServerResponse(){
    return serverResponse;
  }

  void clearState(){
    _map.clear();
    listController.clear();
  }

  TextEditingController? getTextController(String key, String def){
    if(!listController.containsKey(key)){
      TextEditingController textController = TextEditingController();
      if(_map.containsKey(key)){
        textController.text = _map[key];
      }else{
        textController.text = def;
      }
      listController[key] = textController;
      return textController;
    }else{
      return listController[key];
    }
  }

  BuildContext? getCtx() => _ctx;

  void setSyncSocket(bool syncSocket){
    this.syncSocket = syncSocket;
  }

  void Function()? _onIndexRevisionError;

  void setOnIndexRevisionError(void Function()? fn) {
    _onIndexRevisionError = fn;
  }

  void onIndexRevisionError() {
    if (_onIndexRevisionError != null) {
      Function.apply(_onIndexRevisionError!, []);
    }
  }

  void setIndexRevision(int newValue, {bool checkSequence = true}) {
    print("setIndexRevision: ${newValue}; oldValue: ${_indexRevision}");
    if (checkSequence == true) {
      if (_indexRevision == newValue - 1) {
        _indexRevision++;
      } else {
        onIndexRevisionError();
      }
    } else {
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
    //print("Set: $key = $value");
    _map[key] = value;
    if (notify == true) {
      onChange(key);
    }
  }

  void inc(String key, {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
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

  void dec(String key, {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
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
    if (syncSocket) {
      WebSocket().send(getWidgetData("dataUID"), "UPDATE_STATE", data: {"key": key, "value": _map[key]});
    }
  }

  void apply() {
    //print("apply");
    store.dispatch(null);
  }

  void destroy(){
    if (syncSocket) {
      WebSocket().unsubscribe(getWidgetData("dataUID"));
    }
  }

}
