import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'AppStore/AppStore.dart';
import 'AppStore/AppStoreData.dart';
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
    return ShrinkWrapSlivers(null);
  }

}
class ShrinkWrapSlivers extends StatefulWidget {
  AppStoreData? appStoreData;
  ShrinkWrapSlivers(this.appStoreData, {
    Key? key,
  }) : super(key: key);

  @override
  _ShrinkWrapSliversState createState() => _ShrinkWrapSliversState();
}

class _ShrinkWrapSliversState extends State<ShrinkWrapSlivers> {
  List<SliverList> sliverLists = [];

  @override
  void initState() {
    super.initState();

    //String? cachedDataPage = AppStore.cache?.pageGet("/project/to-do/list?uid_data=46d119c9-d7d2-4f6c-9a71-c25b4eac18cd");
    //dynamic data = jsonDecode(cachedDataPage!);
    dynamic data = widget.appStoreData!.getServerResponse();

    int each = 6;
    List listItem = [];
    for (int i = 0; i < data["list"].length; i++) {
      listItem.add(DynamicUI.mainJson(data["list"][i], widget.appStoreData!, i, 'Data'));
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
