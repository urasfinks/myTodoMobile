import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myTODO/AppStore/PageData.dart';
import 'package:myTODO/DynamicPage/DynamicFn.dart';
import 'package:myTODO/DynamicUI/sw/SizeBoxSW.dart';
import 'FlutterType.dart';

class DynamicUI {
  static Widget main(String jsonData, PageData appStoreData, int index, String originKeyData) {
    if (jsonData.isEmpty) {
      return SizedBoxSW(null, appStoreData, index, originKeyData);
    }
    final parsedJson = jsonDecode(jsonData);
    return def(parsedJson, null, SizedBoxSW(null, appStoreData, index, originKeyData), appStoreData, index, originKeyData);
  }

  static dynamic mainJson(Map<String, dynamic> jsonData, PageData appStoreData, int index, String originKeyData) {
    if (jsonData.isEmpty) {
      return SizedBoxSW(jsonData, appStoreData, index, originKeyData);
    }
    return def(jsonData, null, SizedBoxSW(jsonData, appStoreData, index, originKeyData), appStoreData, index, originKeyData);
  }

  static dynamic getByType(String containsKey, map, dynamic def, PageData appStoreData, int index, String? originKeyData) {
    Map<String, Function> map1 = {
      "TextStyle": FlutterType.pTextStyle,
      "Column": FlutterType.pColumn,
      "Row": FlutterType.pRow,
      "Expanded": FlutterType.pExpanded,
      "Padding": FlutterType.pPadding,
      "SizedBox": FlutterType.pSizedBox,
      "Container": FlutterType.pContainer,
      "Center": FlutterType.pCenter,
      "CircleAvatar": FlutterType.pCircleAvatar,
      "Icon": FlutterType.pIcon,
      "AssetImage": FlutterType.pAssetImage,
      "DecorationImage": FlutterType.pDecorationImage,
      "BoxDecoration": FlutterType.pBoxDecoration,
      "Spacer": FlutterType.pSpacer,
      "LinearGradient": FlutterType.pLinearGradient,
      "ElevatedButtonIcon": FlutterType.pElevatedButtonIcon,
      "ElevatedButton": FlutterType.pElevatedButton,
      "ButtonStyle": FlutterType.pButtonStyle,
      "Material": FlutterType.pContainer,
      "InkWell": FlutterType.pInkWell,
      "RoundedRectangleBorder": FlutterType.pRoundedRectangleBorder,
      "Text": FlutterType.pText,
      "SelectableText": FlutterType.pSelectableText,
      "TextField": FlutterType.pTextField,
      "InputDecoration": FlutterType.pInputDecoration,
      "UnderlineInputBorder": FlutterType.pUnderlineInputBorder,
      "OutlineInputBorder": FlutterType.pOutlineInputBorder,
      "BorderSide": FlutterType.pBorderSide,
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
      "NetworkImage": FlutterType.pNetworkImage,
      "ImageNetwork": FlutterType.pImageNetwork,
      "CachedNetworkImage": FlutterType.pCachedNetworkImage,
      "CachedNetworkImageProvider": FlutterType.pCachedNetworkImageProvider,
      "Nothing": FlutterType.pNothing,
      "SegmentControl": FlutterType.pSegmentControl,
      "RawMaterialButton": FlutterType.pRawMaterialButton,
      "DropdownRadio": FlutterType.pDropdownRadio,
      "Visibility": FlutterType.pVisibility,
      "IntroductionScreen": FlutterType.pIntroductionScreen,
      "PageViewModel": FlutterType.pPageViewModel,
      "Slidable": FlutterType.pSlidable,
      "Loop": FlutterType.pLoop,
    };
    //GlobalData.debug("${[map, appStoreData, index, originKeyData]}");
    return map1.containsKey(containsKey) ? Function.apply(map1[containsKey]!, [map, appStoreData, index, originKeyData]) : def;
  }

  static dynamic def(map, key, def, PageData appStoreData, int index, String originKeyData) {
    dynamic ret;
    if (key != null) {
      ret = (map != null && map.containsKey(key)) ? map[key] : def;
    } else {
      ret = map;
    }
    if (map != null) {
      if (ret.runtimeType.toString().startsWith('_InternalLinkedHashMap<String,') && ret.containsKey('flutterType')) {
        return DynamicUI.getByType(ret['flutterType'] as String, ret, def, appStoreData, index, originKeyData);
      }
      //GlobalData.debug(ret);
      if (DynamicFn.isTextFunction(ret)) {
        return DynamicFn.evalTextFunction(ret, map, appStoreData, index, originKeyData);
      }
    }
    return ret;
  }

  static List<Widget> defList(parsedJson, String key, PageData appStoreData, int index, String originKeyData) {
    List<Widget> list = [];
    dynamic l2 = def(parsedJson, key, [], appStoreData, index, originKeyData);
    if (l2 != null && l2.runtimeType.toString().contains("List")) {
      for (int i = 0; i < l2.length; i++) {
        list.add(def(l2[i], null, SizedBoxSW(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData));
      }
    }
    return list;
  }

  static List<PageViewModel> defListPageViewModel(
      parsedJson, String key, PageData appStoreData, int index, String originKeyData) {
    List<PageViewModel> list = [];
    dynamic l2 = def(parsedJson, key, [], appStoreData, index, originKeyData);
    if (l2 != null && l2.runtimeType.toString().contains("List")) {
      for (int i = 0; i < l2.length; i++) {
        list.add(def(l2[i], null, SizedBoxSW(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData));
      }
    }
    return list;
  }
}
