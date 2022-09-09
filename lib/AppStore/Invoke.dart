import 'dart:convert';

import 'PageData.dart';

class Invoke{
  final Function fn;
  final List<String> arg;
  final List<String> extra;
  Invoke(this.fn, this.arg, this.extra);

  static void apply(PageData appStoreData, String jsonControl){
    Map<String, Invoke> map = {
      "inc": Invoke(appStoreData.pageDataState.inc, ["key"], ["step", "min", "max", "fixed"]),
      "dec": Invoke(appStoreData.pageDataState.dec, ["key"], ["step", "min", "max", "fixed"]),
      "set": Invoke(appStoreData.pageDataState.set, ["key", "value"], []),
    };
    final parsedJson = jsonDecode(jsonControl);
    List<dynamic> args = [];
    if(parsedJson!['fn'] != null){
      for(String el in map[parsedJson!['fn']]!.arg){
        args.add(parsedJson!['arg'][el]);
      }
    }
    Map<Symbol, dynamic> extra = {};
    if(parsedJson!['extra'] != null){
      for(String el in map[parsedJson!['fn']]!.extra){
        if(parsedJson!['extra'][el] != null){
          extra[Symbol(el)] = parsedJson!['extra'][el];
        }
      }
    }
    Function.apply(map[parsedJson!['fn']]!.fn, args, extra);
    appStoreData.apply();
  }
}