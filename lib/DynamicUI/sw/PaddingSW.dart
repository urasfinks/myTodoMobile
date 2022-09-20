import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';
import 'SizeBoxSW.dart';

class PaddingSW extends StatelessWidget {
  late final Widget render;
  late final EdgeInsets padding;

  PaddingSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    padding = TypeParser.parseEdgeInsets(
      DynamicUI.def(parsedJson, 'padding', null, appStoreData, index, originKeyData),
    )!;
    render = Padding(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      padding: padding,
      child: DynamicUI.def(
          parsedJson, 'child', SizedBoxSW(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
