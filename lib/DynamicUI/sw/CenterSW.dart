import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import 'SizeBoxSW.dart';

class CenterSW extends StatelessWidget {
  late final Widget render;
  late final Key key;
  late final Widget? child;

  CenterSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    key = Util.getKey(parsedJson, appStoreData, index, originKeyData);
    child = DynamicUI.def(
      parsedJson,
      'child',
      SizedBoxSW(parsedJson, appStoreData, index, originKeyData),
      appStoreData,
      index,
      originKeyData,
    );
    render = Center(
      key: key,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
