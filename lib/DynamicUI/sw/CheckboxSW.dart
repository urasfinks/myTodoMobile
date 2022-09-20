import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class CheckboxSW extends StatelessWidget {
  late final Widget render;

  CheckboxSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    var key = DynamicUI.def(parsedJson, 'name', '-', appStoreData, index, originKeyData);
    bool value = TypeParser.parseBool(
      DynamicUI.def(parsedJson, 'value', false, appStoreData, index, originKeyData),
    )!;
    //appStoreData.set(key, defValue);
    render = Checkbox(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          width: 2.0,
          color: TypeParser.parseColor(value == false
              ? DynamicUI.def(parsedJson, 'borderColor', 'grey', appStoreData, index, originKeyData)
              : 'transparent')!,
        ),
      ),
      value: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'value', false, appStoreData, index, originKeyData),
      ),
      tristate: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'tristate', false, appStoreData, index, originKeyData),
      )!,
      activeColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'activeColor', null, appStoreData, index, originKeyData),
      ),
      focusColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'focusColor', null, appStoreData, index, originKeyData),
      ),
      hoverColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'hoverColor', null, appStoreData, index, originKeyData),
      ),
      checkColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'checkColor', null, appStoreData, index, originKeyData),
      ),
      autofocus: TypeParser.parseBool(
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
