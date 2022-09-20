import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class SlidableSW extends StatelessWidget {
  late final Widget render;

  SlidableSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Slidable(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      endActionPane: ActionPane(
        extentRatio: TypeParser.parseDouble(
          DynamicUI.def(parsedJson, 'extentRatio', 0.3, appStoreData, index, originKeyData),
        )!,
        motion: const ScrollMotion(),
        children: DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
