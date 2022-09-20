import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';
import '../icon.dart';

class IconSW extends StatelessWidget {
  late final Widget render;
  late final double? size;
  late final Color? color;

  IconSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    size = TypeParser.parseDouble(
      DynamicUI.def(parsedJson, 'size', null, appStoreData, index, originKeyData),
    );
    color = TypeParser.parseColor(
      DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
    );
    render = Icon(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      iconsMap[DynamicUI.def(parsedJson, 'src', null, appStoreData, index, originKeyData)],
      color: color,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
