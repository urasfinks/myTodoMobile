import 'package:myTODO/AppStore/ListPageData.dart';
import 'package:myTODO/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Cache.dart';
import '../TabWrap.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert' show utf8, base64;
import 'package:http/http.dart' as http;
import 'dart:developer';

class GlobalData {

  static bool isDebug = true;
  static Cache? cache;
  static String host = "https://jamsys.ru:8443";
  static String promo = "/project/to-do/promo";
  static String ws = "ws://jamsys.ru:8081";
  static String version = "3";
  static int selectedTabIndex = 0;

  static bool firstStart = false;

  static String _personKey = const Uuid().v4();
  static Map<String, String> requestHeader = {};
  static TabWrapState? tabWrapState;

  static void debugFull(dynamic data){
    if(isDebug) {
      log("${data}");
    }
  }

  static void debug(dynamic data){
    if(isDebug){
      print(data);
    }
  }

  static getUriWebSocket(){
    return "$ws/websocket/$_personKey";
  }

  static void updateRequestHeader(){
    String decoded = base64.encode(utf8.encode("PersonKey_$version:$_personKey"));
    requestHeader.addAll({
      'Authorization': "Basic $decoded",
      'Platform' : Util.getPlatformName()
    });
    GlobalData.debug("Person key: $_personKey, header: $requestHeader");
  }

  static changePersonKey(String newPersonKey) async{
    GlobalData.debug("changePersonKey: ${newPersonKey}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key', newPersonKey);
    _personKey = newPersonKey;
    updateRequestHeader();
    ListPageData().reloadAll();
  }

  static Future registerPerson() async {
    String url = "${GlobalData.host}/person/$_personKey";
    GlobalData.debug("registerPerson URL: $url");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await cache?.set('key', _personKey);
      updateRequestHeader();
    }
  }

  static void setPersonKey(String key) {
    _personKey = key;
    updateRequestHeader();
  }

}
