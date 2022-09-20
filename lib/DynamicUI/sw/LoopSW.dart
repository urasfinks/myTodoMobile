import 'package:flutter/cupertino.dart';
import 'package:myTODO/AppStore/GlobalData.dart';
import 'package:myTODO/DynamicPage/DynamicPageUtil.dart';

import '../../AppStore/PageData.dart';
import '../../Util.dart';
import '../DynamicUI.dart';

class LoopSW extends StatelessWidget {
  late final Widget render;

  LoopSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    try {
      String keyStoreField = parsedJson["keyStoreField"] ?? "cache";
      String delimiter = parsedJson["delimiter"] ?? "\n";
      String template = parsedJson["template"] ?? "ListLoop";
      bool emptySkip = parsedJson["emptySkip"] ?? true;
      bool reverse = parsedJson["reverse"] ?? true;
      String nameLoop = parsedJson["nameLoop"] ?? "Loop";
      String nameLoopResult = "${nameLoop}Result";

      String dynData = appStoreData.pageDataState.get(keyStoreField, "");

      Map<String, dynamic> data = appStoreData.getServerResponse();
      data[nameLoop] = [];
      int count = 0;
      List exp = dynData.split(delimiter);
      if (reverse) {
        exp = List.from(exp.reversed);
      }

      for (String item in exp) {
        if (item.isNotEmpty || !emptySkip) {
          Map<String, dynamic> map = {
            "data": {"data": item, "index": count++},
            "template": template
          };
          data[nameLoop].add(map);
        }
      }
      //print(data[nameLoop]);

      DynamicPageUtil.parseTemplate(data, nameLoop, nameLoopResult);

      render = Column(
        key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
        children: _getChild(data[nameLoopResult], appStoreData),
      );
    } catch (e, stacktrace) {
      GlobalData.debug(e);
      GlobalData.debug(stacktrace);
      render = Text(e.toString());
    }
  }

  List<Widget> _getChild(List list, PageData appStoreData) {
    List<Widget> ret = [];
    for (int i = 0; i < list.length; i++) {
      ret.add(DynamicUI.mainJson(list[i], appStoreData, i, ''));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
