import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppStore/PageData.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class CircleAvatarSW extends StatelessWidget {
  late final Widget render;

  CircleAvatarSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    render = CircleAvatar(
      backgroundImage: DynamicUI.def(parsedJson, 'backgroundImage', null, appStoreData, index, originKeyData),
      backgroundColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'backgroundColor', null, appStoreData, index, originKeyData),
      ),
      radius: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'radius', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
