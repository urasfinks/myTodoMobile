import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../FlutterType.dart';
import '../FlutterTypeConstant.dart';
import 'SWSizeBox.dart';

class SWExpanded extends StatelessWidget {
  late final Widget render;

  SWExpanded(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Expanded(
      flex: FlutterTypeConstant.parseInt(
        DynamicUI.def(parsedJson, 'flex', 1, appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', SWSizeBox(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData),
    );
  }


  @override
  Widget build(BuildContext context) {
    return render;
  }
}
