import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class RowSW extends StatelessWidget {
  late final Widget render;

  RowSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Row(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      crossAxisAlignment: TypeParser.parseCrossAxisAlignment(
        DynamicUI.def(parsedJson, 'crossAxisAlignment', 'center', appStoreData, index, originKeyData),
      )!,
      mainAxisAlignment: TypeParser.parseMainAxisAlignment(
        DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', appStoreData, index, originKeyData),
      )!,
      children: DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
