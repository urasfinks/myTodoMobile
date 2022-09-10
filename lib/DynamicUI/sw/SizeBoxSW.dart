import 'package:flutter/cupertino.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class SizedBoxSW extends StatelessWidget {
  late final Widget render;

  SizedBoxSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = SizedBox(
      width: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
      ),
      height: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
