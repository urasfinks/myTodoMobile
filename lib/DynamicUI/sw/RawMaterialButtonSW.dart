import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../../DynamicPage/DynamicFn.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class RawMaterialButtonSW extends StatelessWidget {
  late final Widget render;
  late final Color? fillColor;

  RawMaterialButtonSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    fillColor = TypeParser.parseColor(
      DynamicUI.def(parsedJson, 'fillColor', null, appStoreData, index, originKeyData),
    );
    render = RawMaterialButton(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      fillColor: fillColor,
      focusColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'focusColor', null, appStoreData, index, originKeyData),
      ),
      hoverColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'hoverColor', null, appStoreData, index, originKeyData),
      ),
      splashColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'splashColor', null, appStoreData, index, originKeyData),
      ),
      highlightColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'highlightColor', null, appStoreData, index, originKeyData),
      ),
      padding: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', 0, appStoreData, index, originKeyData),
      )!,
      elevation: 0,
      constraints: BoxConstraints(
        minWidth: TypeParser.parseDouble(
          DynamicUI.def(parsedJson, 'minWidth', 0.0, appStoreData, index, originKeyData),
        )!,
        maxWidth: TypeParser.parseDouble(
          DynamicUI.def(parsedJson, 'maxWidth', "infinity", appStoreData, index, originKeyData),
        )!,
        minHeight: TypeParser.parseDouble(
          DynamicUI.def(parsedJson, 'minHeight', 0.0, appStoreData, index, originKeyData),
        )!,
        maxHeight: TypeParser.parseDouble(
          DynamicUI.def(parsedJson, 'maxHeight', "infinity", appStoreData, index, originKeyData),
        )!,
      ),
      onPressed: DynamicFn.evalTextFunction(parsedJson['onPressed'], parsedJson, appStoreData, index, originKeyData),
      child: DynamicUI.def(parsedJson, 'icon', null, appStoreData, index, originKeyData),
      shape: const CircleBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
