import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';
import 'SizeBoxSW.dart';

class ContainerSW extends StatelessWidget{
  late final Widget render;

  ContainerSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}){
    render = Container(
      margin: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'margin', null, appStoreData, index, originKeyData),
      ),
      padding: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', null, appStoreData, index, originKeyData),
      ),
      width: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
      ),
      height: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', SizedBoxSW(parsedJson, appStoreData, index, originKeyData), appStoreData, index, originKeyData),
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData, index, originKeyData),
      alignment: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', null, appStoreData, index, originKeyData),
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