import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../FlutterType.dart';
import '../FlutterTypeConstant.dart';
import 'SWSizeBox.dart';

class SWContainer extends StatelessWidget{
  late final Widget render;

  SWContainer(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}){
    render = Container(
      margin: FlutterTypeConstant.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'margin', null, appStoreData, index, originKeyData),
      ),
      padding: FlutterTypeConstant.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', null, appStoreData, index, originKeyData),
      ),
      width: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
      ),
      height: FlutterTypeConstant.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', SWSizeBox(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData),
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData, index, originKeyData),
      alignment: FlutterTypeConstant.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', null, appStoreData, index, originKeyData),
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