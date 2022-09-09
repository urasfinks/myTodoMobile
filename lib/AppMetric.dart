import 'package:myTODO/AppStore/GlobalData.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class Ex {
  dynamic e;
  dynamic stacktrace;

  Ex(this.e, this.stacktrace);
}

class AppMetric {
  static final AppMetric _singleton = AppMetric._internal();

  AppMetric._internal();

  factory AppMetric() {
    return _singleton;
  }

  int maxStack = 20;

  List<String> listMsg = [];
  List<Ex> listException = [];
  bool _connect = false;

  activate(String token) {
    if (_connect == false) {
      AppMetrica.runZoneGuarded(() {
        AppMetrica.activate(AppMetricaConfig(token, logs: GlobalData.isDebug));
        _connect = true;
      });
    }
  }

  exception(dynamic e, dynamic stacktrace) async {
    GlobalData.debug(e);
    GlobalData.debug(stacktrace);
    listException.add(Ex(e, stacktrace));
    if (listException.length > maxStack) {
      listException.remove(listException.first);
    }
    if (_connect == true) {
      _backgroundSendException();
    }
  }

  send(String msg) {
    listMsg.add(msg);
    if (listMsg.length > maxStack) {
      listMsg.remove(listMsg.first);
    }
    if (_connect == true) {
      _backgroundSendMsg();
    }
  }

  _backgroundSendException() async {
    int count = 0;
    while (listException.isNotEmpty) {
      count++;
      Ex s = listException.removeLast();
      try {
        AppMetrica.reportUnhandledException(
          AppMetricaErrorDescription.fromObjectAndStackTrace(s.e, s.stacktrace),
        );
      } catch (e, stacktrace) {
        GlobalData.debug(e);
        GlobalData.debug(stacktrace);
      }
      if (count > 100) {
        break;
      }
    }
  }

  _backgroundSendMsg() async {
    int count = 0;
    while (listMsg.isNotEmpty) {
      count++;
      String s = listMsg.removeLast();
      try {
        AppMetrica.reportEvent(s);
      } catch (e, stacktrace) {
        GlobalData.debug(e);
        GlobalData.debug(stacktrace);
      }
      if (count > 100) {
        break;
      }
    }
  }
}
