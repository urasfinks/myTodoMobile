import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../FlutterTypeConstant.dart';

class SWDivider extends StatelessWidget{
  late final Widget render;

  SWDivider(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = Divider(
      height: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      thickness: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'thickness', null, appStoreData, index, originKeyData),
      ),
      endIndent: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'endIndent', null, appStoreData, index, originKeyData),
      ),
      indent: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'indent', null, appStoreData, index, originKeyData),
      ),
      color: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }

}