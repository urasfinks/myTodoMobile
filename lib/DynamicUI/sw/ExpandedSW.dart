import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';
import 'SizeBoxSW.dart';

class ExpandedSW extends StatelessWidget {
  late final Widget render;

  ExpandedSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Expanded(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      flex: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'flex', 1, appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(
          parsedJson, 'child', SizedBoxSW(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
