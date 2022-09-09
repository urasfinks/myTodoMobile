import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';
import '../icon.dart';

class SWIcon extends StatelessWidget {
  late final Widget render;

  SWIcon(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Icon(
      iconsMap[DynamicUI.def(parsedJson, 'src', null, appStoreData, index, originKeyData)],
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      size: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'size', null, appStoreData, index, originKeyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
