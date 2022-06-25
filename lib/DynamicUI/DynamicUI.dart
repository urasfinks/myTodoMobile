import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'FlutterType.dart';


class DynamicUI {

  static Widget main(String jsonData) {
    if (jsonData.isEmpty) {
      return FlutterType.defaultWidget;
    }
    final parsedJson = jsonDecode(jsonData);
    return def(parsedJson, null, FlutterType.defaultWidget);
  }

  static Widget mainJson(Map<String, dynamic> jsonData) {
    //print("Type: ${jsonData.runtimeType.toString()}");
    if (jsonData.isEmpty) {
      return FlutterType.defaultWidget;
    }
    return def(jsonData, null, FlutterType.defaultWidget);
  }

  static dynamic getByType(String containsKey, map, dynamic def) {
    Map<String, Function> map1 = {
      "Text": FlutterType.pText,
      "TextStyle": FlutterType.pTextStyle,
      "Column": FlutterType.pColumn,
      "Row": FlutterType.pRow,
      "Expanded": FlutterType.pExpanded,
      "Padding": FlutterType.pPadding,
      "SizedBox": FlutterType.pSizedBox,
      "Container": FlutterType.pContainer,
      "Center": FlutterType.pCenter,
      "NetworkImage": FlutterType.pNetworkImage,
      "CircleAvatar": FlutterType.pCircleAvatar,
      "Icon": FlutterType.pIcon,
      "AssetImage": FlutterType.pAssetImage,
      "DecorationImage": FlutterType.pDecorationImage,
      "BoxDecoration": FlutterType.pBoxDecoration,
      "Spacer": FlutterType.pSpacer,
      "LinearGradient": FlutterType.pLinearGradient,
      "Divider": FlutterType.pDivider,
      "ElevatedButtonIcon": FlutterType.pElevatedButtonIcon,
      "ButtonStyle": FlutterType.pButtonStyle
    };
    return map1.containsKey(containsKey) ? Function.apply(map1[containsKey]!, [map]) : def;
  }

  static dynamic def(map, key, def) {
    dynamic ret;
    if (key != null) {
      ret = map.containsKey(key) ? map[key] : def;
    } else {
      ret = map;
    }
    if (ret.runtimeType.toString().startsWith('_InternalLinkedHashMap<String,') && ret.containsKey('flutterType')) {
      return DynamicUI.getByType(ret['flutterType'] as String, ret, def);
    }
    return ret;
  }

  static List<Widget> defList(parsedJson, String key) {
    List<Widget> list = [];
    List l2 = def(parsedJson, key, []);
    for (int i = 0; i < l2.length; i++) {
      list.add(def(l2[i], null, FlutterType.defaultWidget));
    }
    return list;
  }

}
