import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../Util.dart';
import 'PageData.dart';

class PageDataState {
  final PageData pageData;

  PageDataState(this.pageData);

  final Map<String, dynamic> _mapState = {};
  Map<String, TextEditingController> listController = {};

  void clear() {
    _mapState.clear();
    listController.clear();
  }

  String getStringStoreState() {
    if (_mapState.isNotEmpty) {
      dynamic sendPrivateState = pageData.pageDataWidget.getWidgetData("sendPrivateState");
      if (sendPrivateState != null && sendPrivateState == true) {
        return jsonEncode(_mapState);
      } else {
        Map<String, dynamic> mapRet = {};
        for (var item in _mapState.entries) {
          if (!item.key.startsWith("_")) {
            mapRet[item.key] = item.value;
          }
        }
        return jsonEncode(mapRet);
      }
    }
    return "";
  }

  dynamic get(String key, dynamic defValue) {
    if (_mapState[key] == null) {
      _mapState[key] = defValue;
    }
    return _mapState[key];
  }

  void set(String key, dynamic value, {bool notify = true}) {
    //GlobalData.debug("Set: $key = $value");
    _mapState[key] = value;
    pageData.onChange(key, notify);
  }

  void join(String key, String appendString, {bool notify = true}) {
    if (_mapState[key] == null) {
      _mapState[key] = "";
    }
    _mapState[key] = _mapState[key] + Util.template(_mapState, appendString);
    pageData.onChange(key, notify);
  }

  void inc(String key, {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
    _mapState[key] = double.parse("${_mapState[key]}") + step;
    if (_mapState[key] < min) {
      _mapState[key] = min;
    }
    if (_mapState[key] > max) {
      _mapState[key] = max;
    }
    _mapState[key] = (_mapState[key]).toStringAsFixed(fixed);
    pageData.onChange(key, notify);
  }

  void dec(String key, {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
    _mapState[key] = double.parse("${_mapState[key]}") - step;
    if (_mapState[key] < min) {
      _mapState[key] = min;
    }
    if (_mapState[key] > max) {
      _mapState[key] = max;
    }
    _mapState[key] = (_mapState[key]).toStringAsFixed(fixed);
    pageData.onChange(key, notify);
  }

  void toggle(String key, {bool notify = true}) {
    String x = "${_mapState[key]}".toLowerCase();
    if (x == "true" || x == "1") {
      _mapState[key] = true;
    } else {
      _mapState[key] = false;
    }
    pageData.onChange(key, notify);
  }

  TextEditingController? getTextController(String key, String def) {
    if (!listController.containsKey(key)) {
      TextEditingController textController = TextEditingController();
      if (_mapState.containsKey(key) && _mapState[key] != null) {
        textController.text = _mapState[key];
      } else {
        textController.text = def;
      }
      listController[key] = textController;
      return textController;
    } else {
      return listController[key];
    }
  }
}
