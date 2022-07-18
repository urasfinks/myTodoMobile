import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test3/AppStore/AppStoreData.dart';
import 'package:test3/DynamicPage/DynamicFn.dart';
import 'FlutterType.dart';

class DynamicUI {
  static Widget main(String jsonData, AppStoreData appStoreData, int index, String originKeyData) {
    if (jsonData.isEmpty) {
      return FlutterType.defaultWidget;
    }
    final parsedJson = jsonDecode(jsonData);
    return def(parsedJson, null, FlutterType.defaultWidget, appStoreData, index, originKeyData);
  }

  static dynamic mainJson(Map<String, dynamic> jsonData, AppStoreData appStoreData, int index, String originKeyData) {
    if (jsonData.isEmpty) {
      return FlutterType.defaultWidget;
    }
    return def(jsonData, null, FlutterType.defaultWidget, appStoreData, index, originKeyData);
  }

  static dynamic getByType(
      String containsKey, map, dynamic def, AppStoreData appStoreData, int index, String? originKeyData) {
    Map<String, Function> map1 = {
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
      "ElevatedButtonIcon": FlutterType.pElevatedButtonIcon,
      "ButtonStyle": FlutterType.pButtonStyle,
      "Material": FlutterType.pMaterial,
      "InkWell": FlutterType.pInkWell,
      "RoundedRectangleBorder": FlutterType.pRoundedRectangleBorder,
      "Text": FlutterType.pText,
      "SelectableText": FlutterType.pSelectableText,
      "TextField": FlutterType.pTextField,
      "InputDecoration": FlutterType.pInputDecoration,
      "UnderlineInputBorder": FlutterType.pUnderlineInputBorder,
      "BorderSize": FlutterType.pBorderSize,
      "GridView": FlutterType.pGridView,
      "ListView": FlutterType.pListView,
      "PageView": FlutterType.pPageView,
      "Align": FlutterType.pAlign,
      "AspectRatio": FlutterType.pAspectRatio,
      "FitBox": FlutterType.pFitBox,
      "Baseline": FlutterType.pBaseline,
      "Stack": FlutterType.pStack,
      "Positioned": FlutterType.pPositioned,
      "Opacity": FlutterType.pOpacity,
      "Wrap": FlutterType.pWrap,
      "ClipRRect": FlutterType.pClipRRect,
      "LimitedBox": FlutterType.pLimitedBox,
      "OverflowBox": FlutterType.pOverflowBox,
      "Divider": FlutterType.pDivider,
      "RotatedBox": FlutterType.pRotatedBox,
      "IconButton": FlutterType.pIconButton,
      "Checkbox": FlutterType.pCheckbox,
      "AppStore": FlutterType.pAppStore,
      "CachedNetworkImage": FlutterType.pCachedNetworkImage,
      "Nothing": FlutterType.pNothing,
    };
    //print("${[map, appStoreData, index, originKeyData]}");
    return map1.containsKey(containsKey)
        ? Function.apply(map1[containsKey]!, [map, appStoreData, index, originKeyData])
        : def;
  }

  static dynamic def(map, key, def, AppStoreData appStoreData, int index, String originKeyData) {
    dynamic ret;
    if (key != null) {
      ret = map.containsKey(key) ? map[key] : def;
    } else {
      ret = map;
    }
    if (ret.runtimeType.toString().startsWith('_InternalLinkedHashMap<String,') && ret.containsKey('flutterType')) {
      return DynamicUI.getByType(ret['flutterType'] as String, ret, def, appStoreData, index, originKeyData);
    }
    //print(ret);
    if (DynamicFn.isTextFunction(ret)) {
      return DynamicFn.evalTextFunction(ret, map, appStoreData, index, originKeyData);
    }
    return ret;
  }

  static List<Widget> defList(parsedJson, String key, AppStoreData appStoreData, int index, String originKeyData) {
    List<Widget> list = [];
    dynamic l2 = def(parsedJson, key, [], appStoreData, index, originKeyData);
    if (l2 != null && l2.runtimeType.toString().contains("List")) {
      for (int i = 0; i < l2.length; i++) {
        list.add(def(l2[i], null, FlutterType.defaultWidget, appStoreData, index, originKeyData));
      }
    }
    return list;
  }
}
