import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../../DynamicPage/DynamicFn.dart';
import '../DynamicUI.dart';
import '../FlutterTypeConstant.dart';

class SWIconButton extends StatelessWidget {
  late final Widget render;

  SWIconButton(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = IconButton(
      icon: DynamicUI.def(parsedJson, 'icon', null, appStoreData, index, originKeyData),
      iconSize: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'iconSize', null, appStoreData, index, originKeyData),
      ),
      splashRadius: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'splashRadius', null, appStoreData, index, originKeyData),
      ),
      color: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      focusColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'focusColor', null, appStoreData, index, originKeyData),
      ),
      hoverColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'hoverColor', null, appStoreData, index, originKeyData),
      ),
      highlightColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'highlightColor', null, appStoreData, index, originKeyData),
      ),
      splashColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'splashColor', null, appStoreData, index, originKeyData),
      ),
      disabledColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'disabledColor', null, appStoreData, index, originKeyData),
      ),
      padding: FlutterTypeConstant.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', '8', appStoreData, index, originKeyData),
      )!,
      alignment: FlutterTypeConstant.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', 'center', appStoreData, index, originKeyData),
      )!,
      tooltip: DynamicUI.def(parsedJson, 'tooltip', null, appStoreData, index, originKeyData),
      autofocus: FlutterTypeConstant.parseBool(
        DynamicUI.def(parsedJson, 'autofocus', false, appStoreData, index, originKeyData),
      )!,
      enableFeedback: FlutterTypeConstant.parseBool(
        DynamicUI.def(parsedJson, 'enableFeedback', true, appStoreData, index, originKeyData),
      )!,
      onPressed: DynamicFn.evalTextFunction(parsedJson['onPressed'], parsedJson, appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
