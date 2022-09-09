import 'dart:convert';

import 'package:flutter/material.dart';
import 'AppStore/GlobalData.dart';
import 'AppStore/PageData.dart';
import 'DynamicPage/DynamicPageUtil.dart';
import 'DynamicUI/DynamicUI.dart';

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
    String? cachedDataPage = GlobalData.cache?.pageGet("/project/to-do/list?uid_data=46d119c9-d7d2-4f6c-9a71-c25b4eac18cd");
    Map<String, dynamic> data = jsonDecode(cachedDataPage!);
    DynamicPageUtil.parseTemplate(data, "Data", "list");
    pd.setServerResponse(data);
    return ShrinkWrapSlivers(pd);
  }
}

class ShrinkWrapSlivers extends StatefulWidget {
  PageData pageData;

  ShrinkWrapSlivers(
    this.pageData, {
    Key? key,
  }) : super(key: key);

  @override
  _ShrinkWrapSliversState createState() => _ShrinkWrapSliversState();
}

class _ShrinkWrapSliversState extends State<ShrinkWrapSlivers> {
  List<Widget> list = [];

  @override
  void initState() {
    dynamic data = widget.pageData!.getServerResponse();
    for (int i = 0; i < data["list"].length; i++) {
      list.add(DynamicUI.mainJson(data["list"][i], widget.pageData!, i, 'Data'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(

          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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

class _ShrinkWrapSliversState2 extends State<ShrinkWrapSlivers> {
  List<SliverList> sliverLists = [];

  @override
  void initState() {
    super.initState();

    //String? cachedDataPage = AppStore.cache?.pageGet("/project/to-do/list?uid_data=46d119c9-d7d2-4f6c-9a71-c25b4eac18cd");
    //dynamic data = jsonDecode(cachedDataPage!);
    dynamic data = widget.pageData!.getServerResponse();

    int each = 100;
    List listItem = [];
    for (int i = 0; i < data["list"].length; i++) {
      listItem.add(DynamicUI.mainJson(data["list"][i], widget.pageData!, i, 'Data'));
      if (listItem.length > each) {
        _put(listItem);
        listItem = [];
      }
    }
    if (listItem.isNotEmpty) {
      _put(listItem);
    }
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
    return CustomScrollView(slivers: sliverLists);
  }
}
