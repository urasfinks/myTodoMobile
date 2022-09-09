import 'package:flutter/cupertino.dart';

import 'AppStore/PageData.dart';

class TabPageHistory{
  final Widget page;
  final List<PageData> history = [];

  TabPageHistory(this.page);
}