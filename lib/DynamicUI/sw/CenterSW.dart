import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import 'SizeBoxSW.dart';

class CenterSW extends StatelessWidget {
  late final Widget render;

  CenterSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Center(
      child: DynamicUI.def(parsedJson, 'child', SizedBoxSW(parsedJson, appStoreData, index, originKeyData),
          appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
