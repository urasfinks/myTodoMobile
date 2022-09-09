import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class SWColumn extends StatelessWidget {
  late final Widget render;

  SWColumn(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Column(
      mainAxisSize: TypeParser.parseMainAxisSize(
        DynamicUI.def(parsedJson, 'mainAxisSize', 'max', appStoreData, index, originKeyData),
      )!,
      crossAxisAlignment: TypeParser.parseCrossAxisAlignment(
        DynamicUI.def(parsedJson, 'crossAxisAlignment', 'center', appStoreData, index, originKeyData),
      )!,
      mainAxisAlignment: TypeParser.parseMainAxisAlignment(
        DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', appStoreData, index, originKeyData),
      )!,
      children: DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData) ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
