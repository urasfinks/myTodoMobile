import '../AppMetric.dart';
import '../DynamicPage/DynamicPageWidget.dart';
import 'PageData.dart';

class PageDataWidget {
  final PageData pageData;

  PageDataWidget(this.pageData);

  Map<String, dynamic> widgetData = {};

  void addWidgetDataByPage(DynamicPageWidget widget) {
    addWidgetData("title", widget.title);
    addWidgetData("root", widget.root);
    addWidgetData("url", widget.url);
    addWidgetData("parentState", widget.parentState);
    addWidgetData("dataUID", widget.dataUID);
    addWidgetData("wrapPage", widget.wrapPage);
    addWidgetData("pullToRefreshBackgroundColor", widget.pullToRefreshBackgroundColor);
    addWidgetData("appBarBackgroundColor", widget.appBarBackgroundColor);
    addWidgetData("backgroundColor", widget.backgroundColor);
    addWidgetData("progressIndicatorBackgroundColor", widget.progressIndicatorBackgroundColor);
    addWidgetData("progressIndicatorColor", widget.progressIndicatorColor);
    addWidgetData("dialog", widget.dialog);
    addWidgetData("modalBottom", widget.modalBottom);
    addWidgetData("separated", widget.separated);
    addWidgetData("grid", widget.grid);
    addWidgetData("config", widget.config);
    addWidgetData("bridgeState", widget.bridgeState);
  }

  void addWidgetData(String key, dynamic value) {
    //GlobalData.debug("addWidgetData(${key}) = ${value}");
    widgetData[key] = value;
    if (key == "parentRefresh") {
      try {
        pageData.setParentRefresh(value);
      } catch (e, stacktrace) {
        AppMetric().exception(e, stacktrace);
      }
    }
  }

  void addWidgetDataByMap(Map<String, dynamic> obj) {
    for (var item in obj.entries) {
      if (item.key != "dataUID") {
        addWidgetData(item.key, item.value);
      }
    }
  }

  Map<String, dynamic> getWidgetDates() {
    return widgetData;
  }

  void setWidgetDataConfig(String key, dynamic value) {
    dynamic x = widgetData["config"];
    x[key] = value;
  }

  dynamic getWidgetDataConfig(Map<String, dynamic> def) {
    dynamic x = widgetData["config"];
    if (x != null && x.runtimeType.toString().contains("Map")) {
      for (var item in x.entries) {
        def[item.key] = item.value;
      }
    }
    return def;
  }

  dynamic getWidgetData(String key) {
    return widgetData.containsKey(key) ? widgetData[key] : null;
  }
}
