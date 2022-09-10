import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class SelectableTextSW extends StatelessWidget {
  late final Widget render;

  SelectableTextSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = SelectableText(
      DynamicUI.def(parsedJson, 'data', '', appStoreData, index, originKeyData),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index, originKeyData),
      textAlign: TypeParser.parseTextAlign(
        DynamicUI.def(parsedJson, 'textAlign', 'start', appStoreData, index, originKeyData),
      )!,
      textDirection: TypeParser.parseTextDirection(
        DynamicUI.def(parsedJson, 'textDirection', null, appStoreData, index, originKeyData),
      ),
      textScaleFactor: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'textScaleFactor', null, appStoreData, index, originKeyData),
      ),
      showCursor: DynamicUI.def(parsedJson, 'showCursor', null, appStoreData, index, originKeyData),
      autofocus: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'autofocus', false, appStoreData, index, originKeyData),
      )!,
      minLines: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'minLines', 1, appStoreData, index, originKeyData),
      ),
      maxLines: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'maxLines', 1, appStoreData, index, originKeyData),
      ),
      cursorColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'cursorColor', null, appStoreData, index, originKeyData),
      ),
      enableInteractiveSelection: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'enableInteractiveSelection', true, appStoreData, index, originKeyData),
      )!,
      textWidthBasis: TypeParser.parseTextWidthBasis(
        DynamicUI.def(parsedJson, 'textWidthBasis', null, appStoreData, index, originKeyData),
      ),
      scrollPhysics: Util.getPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
