import 'package:flutter/material.dart';

import 'main.dart';

void main() {
  runApp(const SettingPage());
}

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      // アプリ名
      title: '設定',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SettingListPage(),
    );
  }
}

class SettingListPage extends StatefulWidget {
  const SettingListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StreamListPageState createState() => _StreamListPageState();
}

class _StreamListPageState extends State<SettingListPage> {
  // Todoリストのデータ
  // ignore: non_constant_identifier_names
  List<String> StreamList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("設定"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MyTodoApp();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
