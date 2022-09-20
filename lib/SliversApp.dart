import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:myTODO/DynamicUI/TypeParser.dart';
import 'AppStore/PageData.dart';
import 'DynamicUI/DynamicUI.dart';
import 'Util.dart';

class ShrinkWrapSlivers extends StatefulWidget {
  PageData pageData;
  bool reverse = false;
  bool rebuild = false;

  ShrinkWrapSlivers(this.pageData, this.rebuild, {Key? key, this.reverse = false}) : super(key: key);

  @override
  _ShrinkWrapSliversState createState() => _ShrinkWrapSliversState();
}

class _ShrinkWrapSliversState extends State<ShrinkWrapSlivers> {
  List<Widget> sliverLists = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget _buildIndicatorForRefreshState(RefreshIndicatorMode refreshState, double radius, double percentageComplete) {
    Color? color = TypeParser.parseColor(widget.pageData.pageDataWidget.getWidgetData("progressIndicatorColor"));
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        const Curve opacityCurve = Interval(
          0.0,
          0.35,
          curve: Curves.easeInOut,
        );
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: CupertinoActivityIndicator.partiallyRevealed(
            radius: radius,
            progress: percentageComplete,
            color: color,
          ),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        return CupertinoActivityIndicator(
          radius: radius,
          color: color,
        );
      case RefreshIndicatorMode.done:
        return CupertinoActivityIndicator(
          radius: radius * percentageComplete,
          color: color,
        );
      case RefreshIndicatorMode.inactive:
        return Container();
    }
  }

  void _addRefresh() {
    sliverLists.add(
      CupertinoSliverRefreshControl(
        //refreshIndicatorExtent: 60,
        //refreshTriggerPullDistance: Util.isAndroid() ? 125 : 115,
        onRefresh: () async {
          await widget.pageData.getPageState()?.load(pause: false, prepareDelay: true);
        },
        builder: (
          BuildContext context,
          RefreshIndicatorMode refreshState,
          double pulledExtent,
          double refreshTriggerPullDistance,
          double refreshIndicatorExtent,
        ) {
          final double percentageComplete = clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);

          return Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  top: 16.0,
                  left: 0.0,
                  right: 0.0,
                  child: _buildIndicatorForRefreshState(refreshState, 14.0, percentageComplete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _init() {
    //GlobalData.debug("Sliver init");
    sliverLists.clear();
    if (widget.reverse == false) {
      _addRefresh();
    }

    //String? cachedDataPage = AppStore.cache?.pageGet("/project/to-do/list?uid_data=46d119c9-d7d2-4f6c-9a71-c25b4eac18cd");
    //dynamic data = jsonDecode(cachedDataPage!);
    dynamic data = widget.pageData.getServerResponse();

    int each = 7;
    List listItem = [];
    for (int i = 0; i < data["list"].length; i++) {
      listItem.add(DynamicUI.mainJson(data["list"][i], widget.pageData, i, 'Data'));
      if (listItem.length > each) {
        _put(listItem);
        listItem = [];
      }
    }
    if (listItem.isNotEmpty) {
      _put(listItem);
    }
    widget.rebuild = false;
  }

  _put(List listItem) {
    sliverLists.add(
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => listItem[index],
          childCount: listItem.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //GlobalData.debug("Sliver build");
    if (widget.rebuild == true) {
      _init();
    }
    return CustomScrollView(
      primary: true,
      reverse: widget.reverse,
      slivers: sliverLists,
      cacheExtent: 2000,
      physics: Util.getPhysics(),
    );
  }
}
