import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class MaterialSW extends StatelessWidget {
  late final Widget render;

  MaterialSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Material(
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      borderRadius: TypeParser.parseBorderRadius(
        DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
