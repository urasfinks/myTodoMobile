import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../../DynamicPage/DynamicFn.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class SWIconButton extends StatelessWidget {
  late final Widget render;

  SWIconButton(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = IconButton(
      icon: DynamicUI.def(parsedJson, 'icon', null, appStoreData, index, originKeyData),
      iconSize: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'iconSize', null, appStoreData, index, originKeyData),
      ),
      splashRadius: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'splashRadius', null, appStoreData, index, originKeyData),
      ),
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      focusColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'focusColor', null, appStoreData, index, originKeyData),
      ),
      hoverColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'hoverColor', null, appStoreData, index, originKeyData),
      ),
      highlightColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'highlightColor', null, appStoreData, index, originKeyData),
      ),
      splashColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'splashColor', null, appStoreData, index, originKeyData),
      ),
      disabledColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'disabledColor', null, appStoreData, index, originKeyData),
      ),
      padding: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', '8', appStoreData, index, originKeyData),
      )!,
      alignment: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', 'center', appStoreData, index, originKeyData),
      )!,
      tooltip: DynamicUI.def(parsedJson, 'tooltip', null, appStoreData, index, originKeyData),
      autofocus: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'autofocus', false, appStoreData, index, originKeyData),
      )!,
      enableFeedback: TypeParser.parseBool(
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
