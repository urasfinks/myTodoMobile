import 'package:flutter/cupertino.dart';

import '../../AppStore/AppStoreData.dart';
import '../DynamicUI.dart';
import '../FlutterTypeConstant.dart';
import '../icon.dart';

class SWIcon extends StatelessWidget {
  late final Widget render;

  SWIcon(parsedJson, AppStoreData appStoreData, int index, String originKeyData, {super.key}) {
    render = Icon(
      iconsMap[DynamicUI.def(parsedJson, 'src', null, appStoreData, index, originKeyData)],
      color: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      size: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'size', null, appStoreData, index, originKeyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
