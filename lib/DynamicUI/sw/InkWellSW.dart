import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../../DynamicPage/DynamicFn.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class InkWellSW extends StatelessWidget {
  late final Widget render;

  InkWellSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = InkWell(
      customBorder: DynamicUI.def(parsedJson, 'customBorder', null, appStoreData, index, originKeyData),
      splashColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'splashColor', null, appStoreData, index, originKeyData),
      ),
      highlightColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'highlightColor', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
      onTap: DynamicFn.evalTextFunction(parsedJson['onTap'], parsedJson, appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
