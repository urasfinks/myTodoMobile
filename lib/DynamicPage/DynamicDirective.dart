import 'package:intl/intl.dart';
import 'package:myTODO/DynamicUI/FlutterTypeConstant.dart';

import '../AppStore/AppStoreData.dart';

class DynamicDirective{
  static dynamic formatNumber(AppStoreData appStoreData, dynamic data, dynamic map) {
    if(data == null || data.toString() == ""){
      return "";
    }
    return NumberFormat(map["format"]).format(FlutterTypeConstant.parseDouble(data.toString())!);
  }

  static dynamic timestampToDate(AppStoreData appStoreData, dynamic data, dynamic map) {
    if(data == null || data.toString() == ""){
      return "";
    }
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(FlutterTypeConstant.parseInt(data.toString())!);
    return DateFormat(map["format"]).format(dt);
  }


}