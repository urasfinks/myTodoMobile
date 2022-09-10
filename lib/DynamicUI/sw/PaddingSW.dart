import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';
import 'SizeBoxSW.dart';

class PaddingSW extends StatelessWidget {
  late final Widget render;

  PaddingSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Padding(
      padding: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', null, appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', SizedBoxSW(parsedJson, appStoreData, index, originKeyData),
          appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
