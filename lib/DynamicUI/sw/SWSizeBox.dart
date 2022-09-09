import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../FlutterTypeConstant.dart';

class SWSizeBox extends StatelessWidget {
  late final Widget render;

  SWSizeBox(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = SizedBox(
      width: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
      ),
      height: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
