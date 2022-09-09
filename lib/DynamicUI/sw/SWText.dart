import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../FlutterTypeConstant.dart';

class SWText extends StatelessWidget {
  late final Widget render;

  SWText(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Text(
      DynamicUI.def(parsedJson, 'data', '', appStoreData, index, originKeyData).toString(),
      textDirection: FlutterTypeConstant.parseTextDirection(
        DynamicUI.def(parsedJson, 'textDirection', null, appStoreData, index, originKeyData),
      ),
      textAlign: FlutterTypeConstant.parseTextAlign(
        DynamicUI.def(parsedJson, 'textAlign', null, appStoreData, index, originKeyData),
      ),
      softWrap: DynamicUI.def(parsedJson, 'softWrap', null, appStoreData, index, originKeyData),
      overflow: FlutterTypeConstant.parseTextOverflow(
        DynamicUI.def(parsedJson, 'overflow', null, appStoreData, index, originKeyData),
      ),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index, originKeyData),
      textScaleFactor: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'textScaleFactor', null, appStoreData, index, originKeyData),
      ),
      maxLines: FlutterTypeConstant.parseInt(
        DynamicUI.def(parsedJson, 'maxLines', null, appStoreData, index, originKeyData),
      ),
      textWidthBasis: FlutterTypeConstant.parseTextWidthBasis(
        DynamicUI.def(parsedJson, 'textWidthBasis', null, appStoreData, index, originKeyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
