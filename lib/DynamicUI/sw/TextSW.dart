import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class TextSW extends StatelessWidget {
  late final Widget render;
  late final String text;
  late final Key key;
  late final TextDirection? textDirection;
  late final TextAlign? textAlign;
  late final bool? softWrap;
  late final TextOverflow? overflow;
  late final TextStyle? textStyle;
  late final double? textScaleFactor;
  late final int? maxLine;
  late final TextWidthBasis? textWidthBasis;

  TextSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    text = DynamicUI.def(parsedJson, 'data', '', appStoreData, index, originKeyData).toString();
    key = Util.getKey(parsedJson, appStoreData, index, originKeyData);
    textDirection = TypeParser.parseTextDirection(
      DynamicUI.def(parsedJson, 'textDirection', null, appStoreData, index, originKeyData),
    );
    textAlign = TypeParser.parseTextAlign(
      DynamicUI.def(parsedJson, 'textAlign', null, appStoreData, index, originKeyData),
    );
    softWrap = DynamicUI.def(parsedJson, 'softWrap', null, appStoreData, index, originKeyData);
    overflow = TypeParser.parseTextOverflow(
      DynamicUI.def(parsedJson, 'overflow', null, appStoreData, index, originKeyData),
    );
    textStyle = DynamicUI.def(parsedJson, 'style', null, appStoreData, index, originKeyData);
    textScaleFactor = TypeParser.parseDouble(
      DynamicUI.def(parsedJson, 'textScaleFactor', null, appStoreData, index, originKeyData),
    );
    maxLine = TypeParser.parseInt(
      DynamicUI.def(parsedJson, 'maxLines', null, appStoreData, index, originKeyData),
    );
    textWidthBasis = TypeParser.parseTextWidthBasis(
      DynamicUI.def(parsedJson, 'textWidthBasis', null, appStoreData, index, originKeyData),
    );
    //render = const Text("Hello world");
    render = Text(
      text,
      key: key,
      textDirection: textDirection,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      style: textStyle,
      textScaleFactor: textScaleFactor,
      maxLines: maxLine,
      textWidthBasis: textWidthBasis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
