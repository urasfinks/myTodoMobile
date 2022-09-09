import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class SWText extends StatelessWidget {
  late final Widget render;

  SWText(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Text(
      DynamicUI.def(parsedJson, 'data', '', appStoreData, index, originKeyData).toString(),
      textDirection: TypeParser.parseTextDirection(
        DynamicUI.def(parsedJson, 'textDirection', null, appStoreData, index, originKeyData),
      ),
      textAlign: TypeParser.parseTextAlign(
        DynamicUI.def(parsedJson, 'textAlign', null, appStoreData, index, originKeyData),
      ),
      softWrap: DynamicUI.def(parsedJson, 'softWrap', null, appStoreData, index, originKeyData),
      overflow: TypeParser.parseTextOverflow(
        DynamicUI.def(parsedJson, 'overflow', null, appStoreData, index, originKeyData),
      ),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index, originKeyData),
      textScaleFactor: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'textScaleFactor', null, appStoreData, index, originKeyData),
      ),
      maxLines: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'maxLines', null, appStoreData, index, originKeyData),
      ),
      textWidthBasis: TypeParser.parseTextWidthBasis(
        DynamicUI.def(parsedJson, 'textWidthBasis', null, appStoreData, index, originKeyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
