import 'package:flutter/cupertino.dart';

import 'AppStore/AppStoreData.dart';

class TabPageHistory{
  final Widget page;
  final List<AppStoreData> history = [];

  TabPageHistory(this.page);
}