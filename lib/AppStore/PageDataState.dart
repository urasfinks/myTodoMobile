import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../Util.dart';
import 'GlobalData.dart';
import 'PageData.dart';

class PageDataState {
  final PageData pageData;

  PageDataState(this.pageData);

  final Map<String, dynamic> _mapState = {};
  Map<String, TextEditingController> listController = {};
  Map<String, FocusNode> listFocusNode = {};

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

  void set(String key, dynamic value, {bool notify = true, bool isNewValue = false}) {
    if (_mapState[key] != value) {
      //GlobalData.debug("PageDataState Set: $key = $value");
      _mapState[key] = value;
      if(isNewValue == false){
        pageData.onChange(key, notify);
      }
    }
  }

  void removeExplode(String key, String delimiter, int index, {bool notify = true, bool reverse = false}) {
    //GlobalData.debug("removeExplode: key: $key, delimiter: $delimiter, index: $index, notify: $notify, reverse: $reverse");
    if (_mapState[key] == null) {
      _mapState[key] = "";
    }
    String x = _mapState[key];
    List<String> exp = x.split(delimiter);
    //GlobalData.debug(exp);
    if(reverse == true){
      index++; //[, Втрой, Первый] - в конце перенос строки \n переворачивается в начало и индексация слетает
      // Я так полумал, что это будет работать не только на разделитель с переносом а для всех случаев,
      // так как добавления используется всегда функцией joinAppStoreData, которая всегда в конец будет добавлять разделитель
      // Других случаев я пока не смог придумать
      exp = List.from(exp.reversed);
    }
    //GlobalData.debug(exp);
    exp.removeAt(index);
    //GlobalData.debug(exp);
    if(reverse == true){
      exp = List.from(exp.reversed);
    }
    //GlobalData.debug(exp);
    _mapState[key] = exp.join(delimiter);
    pageData.onChange(key, notify);
  }

  void join(String key, String appendString, {bool notify = true, bool emptyJoin = false}) {
    if (_mapState[key] == null) {
      _mapState[key] = "";
    }
    String append = Util.template(_mapState, appendString);
    if (append.trim().isNotEmpty || emptyJoin == true) {
      _mapState[key] = _mapState[key] + append;
      pageData.onChange(key, notify);
    }
  }

  void inc(String key,
      {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
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

  void dec(String key,
      {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
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

  void clear() {
    _mapState.clear();
    listController.clear();
    listFocusNode.clear();
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

  FocusNode? getFocusNode(String key) {
    if (!listFocusNode.containsKey(key)) {
      listFocusNode[key] = FocusNode();
    }
    return listFocusNode[key];
  }
}
