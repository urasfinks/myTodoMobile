import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';
import 'SizeBoxSW.dart';

class ContainerSW extends StatelessWidget {
  late final Widget render;
  late final EdgeInsets? margin;
  late final EdgeInsets? padding;
  late final double? width;
  late final double? height;
  late final Color? color;
  late final Widget? child;
  late final Decoration? decoration;
  late final AlignmentGeometry? alignmentGeometry;

  ContainerSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    margin = TypeParser.parseEdgeInsets(
      DynamicUI.def(parsedJson, 'margin', null, appStoreData, index, originKeyData),
    );
    padding = TypeParser.parseEdgeInsets(
      DynamicUI.def(parsedJson, 'padding', null, appStoreData, index, originKeyData),
    );
    width = TypeParser.parseDouble(
      DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
    );
    height = TypeParser.parseDouble(
      DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
    );
    color = TypeParser.parseColor(
      DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
    );
    decoration = DynamicUI.def(parsedJson, 'decoration', null, appStoreData, index, originKeyData);
    child = DynamicUI.def(
        parsedJson, 'child', SizedBoxSW(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData);
    alignmentGeometry = TypeParser.parseAlignment(
      DynamicUI.def(parsedJson, 'alignment', null, appStoreData, index, originKeyData),
    );
    render = Container(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: decoration,
      alignment: alignmentGeometry,
      color: color,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
