import 'package:flutter/cupertino.dart';

class Util {
  static ListView getListView(
      bool separated,
      ScrollPhysics physics,
      EdgeInsetsGeometry? padding,
      int itemCount,
      IndexedWidgetBuilder itemBuilder,
      IndexedWidgetBuilder separatorBuilder) {
    if (separated == true) {
      return ListView.separated(
        physics: physics,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
      );
    } else {
      return ListView.builder(
        physics: physics,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }
  }
}
