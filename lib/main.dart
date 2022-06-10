import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'AppStore/AppStore.dart';
import 'TabWrap.dart';
import 'package:appwrite/appwrite.dart';

Future<void> appWrite() async {
  Client client = Client();

  client
          .setEndpoint('http://jamsys.ru/v1') // Your Appwrite Endpoint
          .setProject('62a31fb742577aae60b1') // Your project ID
          .setSelfSigned(
              status:
                  true) // For self signed certificates, only use for development
      ;
  Account account = Account(client);

  final user = await account.create(
      userId: 'unique()',
      email: 'me@appwrite.io',
      password: 'password',
      name: 'My Name');

  print(user);

  final realtime = Realtime(client);
  final subscription = realtime.subscribe(['files']);

  subscription.stream.listen((response) {
    print(response);
  });
}

void main() {
  runApp(const RouterPage());
  appWrite();
}

class RouterPage extends StatelessWidget {
  const RouterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: AppStore.store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute(
              builder: (_) => const TabWrap(), settings: settings);
        },
      ),
    );
  }
}
