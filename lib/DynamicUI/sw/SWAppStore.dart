import 'package:flutter/cupertino.dart';

import '../../AppStore/AppStore.dart';
import '../../AppStore/AppStoreData.dart';
import '../DynamicUI.dart';
import 'SWSizeBox.dart';

class SWAppStore extends StatelessWidget {
  late final Widget render;

  SWAppStore(parsedJson, AppStoreData appStoreData, int index, String originKeyData, {super.key}) {
    render = AppStore.connect(appStoreData, (def) {
      return DynamicUI.def(parsedJson, 'child', SWSizeBox(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData);;
    }, defaultValue: 1);
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
