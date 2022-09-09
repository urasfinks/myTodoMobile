import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../FlutterTypeConstant.dart';

class SWCheckbox extends StatelessWidget {
  late final Widget render;

  SWCheckbox(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    var key = DynamicUI.def(parsedJson, 'name', '-', appStoreData, index, originKeyData);
    bool value = FlutterTypeConstant.parseBool(
      DynamicUI.def(parsedJson, 'value', false, appStoreData, index, originKeyData),
    )!;
    //appStoreData.set(key, defValue);
    render =  Checkbox(
      side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(
          width: 2.0,
          color: FlutterTypeConstant.parseColor(value == false
              ? DynamicUI.def(parsedJson, 'borderColor', 'grey', appStoreData, index, originKeyData)
              : 'transparent')!,
        ),
      ),
      value: FlutterTypeConstant.parseBool(
        DynamicUI.def(parsedJson, 'value', false, appStoreData, index, originKeyData),
      ),
      tristate: FlutterTypeConstant.parseBool(
        DynamicUI.def(parsedJson, 'tristate', false, appStoreData, index, originKeyData),
      )!,
      activeColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'activeColor', null, appStoreData, index, originKeyData),
      ),
      focusColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'focusColor', null, appStoreData, index, originKeyData),
      ),
      hoverColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'hoverColor', null, appStoreData, index, originKeyData),
      ),
      checkColor: FlutterTypeConstant.parseColor(
        DynamicUI.def(parsedJson, 'checkColor', null, appStoreData, index, originKeyData),
      ),
      autofocus: FlutterTypeConstant.parseBool(
        DynamicUI.def(parsedJson, 'autofocus', false, appStoreData, index, originKeyData),
      )!,
      splashRadius: DynamicUI.def(parsedJson, 'splashRadius', null, appStoreData, index, originKeyData),
      onChanged: (bool? value) {
        appStoreData.pageDataState.set(key, value);
        //print("onChanged: ${value}; ${appStoreData.getStringStoreState()}");
        appStoreData.apply();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
