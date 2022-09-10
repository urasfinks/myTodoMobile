import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class DividerSW extends StatelessWidget{
  late final Widget render;

  DividerSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Divider(
      height: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      thickness: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'thickness', null, appStoreData, index, originKeyData),
      ),
      endIndent: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'endIndent', null, appStoreData, index, originKeyData),
      ),
      indent: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'indent', null, appStoreData, index, originKeyData),
      ),
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }

}