import 'package:intl/intl.dart';
import 'package:test3/DynamicUI/FlutterTypeConstant.dart';

import '../AppStore/AppStoreData.dart';

class DynamicDirective{
  static dynamic timestampToDate(AppStoreData appStoreData, dynamic data, dynamic map) {
    if(data == null || data == ""){
      return "";
    }
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(FlutterTypeConstant.parseInt(data.toString())!);
    return DateFormat(map["format"]).format(dt);
  }
}