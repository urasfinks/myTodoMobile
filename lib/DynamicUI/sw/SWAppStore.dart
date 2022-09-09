import 'package:flutter/cupertino.dart';

import '../../AppStore/GlobalData.dart';
import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import 'SWSizeBox.dart';

class SWAppStore extends StatelessWidget {
  late final Widget render;

  SWAppStore(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = DynamicUI.def(parsedJson, 'child', SWSizeBox(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData);
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
