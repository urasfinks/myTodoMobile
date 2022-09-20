import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class SizedBoxSW extends StatelessWidget {
  late final Widget render;
  late final double? width;
  late final double? height;
  late final Widget? child;

  SizedBoxSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    width = TypeParser.parseDouble(
      DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
    );
    height = TypeParser.parseDouble(
      DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
    );
    child = DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData);
    render = SizedBox(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      width: width,
      height: height,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
