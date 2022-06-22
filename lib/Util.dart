import 'package:flutter/cupertino.dart';
import 'package:stubble/stubble.dart';

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

  //print(Util.template({'name': 'Stubble', 'test':{'x':'y'}}, 'Hello! I\'m {{test.x}}! Nice to meet you!'));
  static String template(dynamic data, String template){
    final s = Stubble();
    final fn = s.compile(template);
    return fn(data);
  }

}
