import 'package:intl/intl.dart';
import 'package:myTODO/AppStore/GlobalData.dart';
import 'package:myTODO/DynamicUI/TypeParser.dart';

import '../AppStore/PageData.dart';
import 'DynamicFn.dart';

class DynamicDirective{
  static dynamic formatNumber(PageData appStoreData, dynamic data, dynamic map) {
    if(data == null || data.toString() == ""){
      return "";
    }
    return NumberFormat(map["format"]).format(TypeParser.parseDouble(data.toString())!);
  }

  static dynamic timestampToDate(PageData appStoreData, dynamic data, dynamic map) {
    if(data == null || data.toString() == ""){
      return "";
    }
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(TypeParser.parseInt(data.toString())!);
    return DateFormat(map["format"]).format(dt);
  }

  static dynamic bridgeDynamicFn(PageData appStoreData, dynamic data, dynamic map) {
    //GlobalData.debug("bridgeDynamicFn data: $data; map: $map");
    map["prevReturn"] = data;
    return Function.apply(DynamicFn.parseUtilFunction(map["fn"]), [appStoreData, map]);
  }



}