import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'AppStore/GlobalData.dart';
import 'AppStore/PageData.dart';
import 'DynamicPage/DynamicPageUtil.dart';
import 'DynamicUI/DynamicUI.dart';
import 'DynamicUI/TypeParser.dart';
import 'Util.dart';

class SliversApp extends StatelessWidget {
  const SliversApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShrinkWrap vs Slivers',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Revenge of the Slivers"),
        ),
        body: ShrinkWrapSlivers_f(),
      ),
    );
  }
}

class ShrinkWrapSlivers_f extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //appStoreData = AppStoreData(null);
    PageData pd = PageData();
    String? cachedDataPage =
        GlobalData.cache?.pageGet("/project/to-do/list?uid_data=46d119c9-d7d2-4f6c-9a71-c25b4eac18cd");
    Map<String, dynamic> data = jsonDecode(cachedDataPage!);
    DynamicPageUtil.parseTemplate(data, "Data", "list");
    pd.setServerResponse(data);
    return ShrinkWrapSlivers(pd, true);
  }
}

class ShrinkWrapSlivers extends StatefulWidget {
  PageData pageData;
  bool reverse = false;
  bool rebuild = false;

  ShrinkWrapSlivers(this.pageData, this.rebuild, {Key? key, this.reverse = false}) : super(key: key);

  @override
  _ShrinkWrapSliversState createState() => _ShrinkWrapSliversState();
}

class _ShrinkWrapSliversState2 extends State<ShrinkWrapSlivers> {
  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    list = [];
    dynamic data = widget.pageData.getServerResponse();
    for (int i = 0; i < data["list"].length; i++) {
      list.add(DynamicUI.mainJson(data["list"][i], widget.pageData, i, 'Data'));
      //list.add(const Text("Очень большой текст Очень большой текст Очень большой текст Очень большой текст Очень большой текст Очень большой текст Очень большой текст Очень большой текст Очень большой текст "));
    }
    widget.rebuild = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rebuild == true) {
      initState();
    }
    //print("Sliver build");
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          reverse: widget.reverse,
          physics: Util.getPhysics(),
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        );
      },
    );
  }
}

class _ShrinkWrapSliversState extends State<ShrinkWrapSlivers> {
  List<Widget> sliverLists = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget _buildIndicatorForRefreshState(RefreshIndicatorMode refreshState, double radius, double percentageComplete) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        // While we're dragging, we draw individual ticks of the spinner while simultaneously
        // easing the opacity in. Note that the opacity curve values here were derived using
        // Xcode through inspecting a native app running on iOS 13.5.
        const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: Center(
            child: SizedBox(
              height: radius * percentageComplete,
              width: radius * percentageComplete,
              child: CircularProgressIndicator(
                backgroundColor: TypeParser.parseColor(
                  widget.pageData.pageDataWidget.getWidgetData("progressIndicatorBackgroundColor"),
                ),
                color: TypeParser.parseColor(
                  widget.pageData.pageDataWidget.getWidgetData("progressIndicatorColor"),
                ),
              ),
            ),
          ),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        return Center(
          child: SizedBox(
            height: radius,
            width: radius,
            child: CircularProgressIndicator(
              backgroundColor: TypeParser.parseColor(
                widget.pageData.pageDataWidget.getWidgetData("progressIndicatorBackgroundColor"),
              ),
              color: TypeParser.parseColor(
                widget.pageData.pageDataWidget.getWidgetData("progressIndicatorColor"),
              ),
            ),
          ),
        );
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        //return CupertinoActivityIndicator(radius: radius * percentageComplete, color: Colors.blue);

        return Center(
          child: SizedBox(
            height: radius * percentageComplete,
            width: radius * percentageComplete,
            child: CircularProgressIndicator(
              backgroundColor: TypeParser.parseColor(
                widget.pageData.pageDataWidget.getWidgetData("progressIndicatorBackgroundColor"),
              ),
              color: TypeParser.parseColor(
                widget.pageData.pageDataWidget.getWidgetData("progressIndicatorColor"),
              ),
            ),
          ),
        );
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        return const SizedBox.shrink();
    }
  }

  void _init() {
    GlobalData.debug("Sliver init");
    sliverLists.clear();
    sliverLists.add(CupertinoSliverRefreshControl(
      refreshIndicatorExtent: 145,
      refreshTriggerPullDistance: 145,
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
                top: 16,
                left: 0.0,
                right: 0.0,
                child: _buildIndicatorForRefreshState(refreshState, 40, percentageComplete),
              ),
            ],
          ),
        );
      },
      onRefresh: () async {
        await widget.pageData.getPageState()?.load(pause: false, prepareDelay: true);
      },
    ));
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
    GlobalData.debug("Sliver build");
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
