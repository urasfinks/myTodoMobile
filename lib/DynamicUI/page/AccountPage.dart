import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../FlutterTypeConstant.dart';

class AccountPage extends StatefulWidget {
  final String title;

  const AccountPage({super.key, required this.title});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterTypeConstant.parseColor("#f9fafa"),
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topRight, colors: [Colors.blue[600]!, Colors.blue[700]!, Colors.blue[800]!]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: FlutterTypeConstant.parseEdgeInsets("0,0,30,0"),
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.notifications_active,
                      size: 24,
                      color: FlutterTypeConstant.parseColor("#ffffff"),
                    ),
                    onTap: (){
                      print("Halom");
                    },
                  )
                  ,
                  Text(
                    " 3",
                    style: TextStyle(fontSize: 17, color: FlutterTypeConstant.parseColor("#ffffff")),
                  )
                ],
              ),
            ), //,
            CircleAvatar(
              radius: 82,
              backgroundColor: FlutterTypeConstant.parseColor("rgba:255,255,255,0.1"),
              child: const CircleAvatar(
                backgroundImage: NetworkImage("http://jamsys.ru:8081/404.jpg"),
                radius: 70,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Юрий Сергеевич М.",
              style: TextStyle(fontSize: 24, color: FlutterTypeConstant.parseColor("#ffffff")),
            ),
            const SizedBox(height: 10),
            Text(
              "Последний раз были: 24.06.2022 15:06",
              style: TextStyle(fontSize: 14, color: FlutterTypeConstant.parseColor("rgba:255,255,255,0.5")),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterTypeConstant.parseColor("#f5f5f5"),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 100,
                      margin: FlutterTypeConstant.parseEdgeInsets("10,0,10,0"),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topRight, colors: [FlutterTypeConstant.parseColor("rgba:255,255,255,0.5")!, FlutterTypeConstant.parseColor("#f5f5f5")!]),
                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Container(
                        padding: FlutterTypeConstant.parseEdgeInsets("20,20,20,0"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                splashColor: Colors.grey[200],
                                highlightColor: Colors.transparent,
                                onTap: (){
                                  print("Tap");
                                },
                                child: Container(
                                  padding: FlutterTypeConstant.parseEdgeInsets("5,12,5,0"),
                                  width: 100,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: const [
                                      Icon(Icons.cancel, size: 18, color: Colors.red),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Аккаунт",
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: FlutterTypeConstant.parseEdgeInsets("5,12,5,0"),
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                color: FlutterTypeConstant.parseColor("#ffffff"),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: const [
                                  Icon(Icons.note, size: 18, color: Colors.black),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Записи", style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                            Container(
                              padding: FlutterTypeConstant.parseEdgeInsets("5,12,5,0"),
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                color: FlutterTypeConstant.parseColor("#ffffff"),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: const [
                                  Icon(Icons.favorite, size: 18, color: Colors.black),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Избранное", style: TextStyle(color: Colors.black))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 43,
                      width: double.infinity,
                      padding: FlutterTypeConstant.parseEdgeInsets("0,0,7,0"),
                      margin: FlutterTypeConstant.parseEdgeInsets("32,0,32,0"),
                      decoration: BoxDecoration(
                        color: FlutterTypeConstant.parseColor("#ffffff"),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: FlutterTypeConstant.parseEdgeInsets("10,8,10,0"),
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(0), bottomLeft: Radius.circular(20)),
                              ),
                              child: Column(
                                children: const [
                                  Text("25", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text(
                                    "ПН",
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 7,
                                ),
                                Text("26", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                Text("ВТ", style: TextStyle(color: Colors.black, fontSize: 10))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 7,
                                ),
                                Text("27", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                Text("СР", style: TextStyle(color: Colors.black, fontSize: 10))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 7,
                                ),
                                Text("28", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                Text("ЧТ", style: TextStyle(color: Colors.black, fontSize: 10))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 7,
                                ),
                                Text("29", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                Text("ПТ", style: TextStyle(color: Colors.black, fontSize: 10))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: FlutterTypeConstant.parseEdgeInsets("32,0,32,0"),
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "     Группы:",
                            style: TextStyle(fontWeight: FontWeight.bold, color: FlutterTypeConstant.parseColor("#999999")),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: FlutterTypeConstant.parseEdgeInsets("0,10,0,10"),
                            width: double.infinity,
                            decoration: BoxDecoration(color: FlutterTypeConstant.parseColor("#ffffff"), borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: FlutterTypeConstant.parseEdgeInsets("15,10,10,10"),
                                  child: const Text("Основная"),
                                ),
                                Divider(height: 1, color: FlutterTypeConstant.parseColor("#f5f5f5"),),
                                Container(
                                  padding: FlutterTypeConstant.parseEdgeInsets("15,10,10,10"),
                                  child: const Text("Вторичная"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: FlutterTypeConstant.parseEdgeInsets("32,0,32,0"),
                      child: SizedBox(
                        width: double.infinity,
                        height: 43,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue[600]!),
                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text(
                            "Изменить данные профиля",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
