import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stream_notif/setting.dart';

void main() {
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      // アプリ名
      title: 'Twitch live streamer',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // リスト一覧画面を表示
      home: const StreamListPage(),
    );
  }
}

class StreamListPage extends StatefulWidget {
  const StreamListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StreamListPageState createState() => _StreamListPageState();
}

class _StreamListPageState extends State<StreamListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // AppBarを表示し、タイトルも設定

        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SettingPage();
                    },
                  ),
                );
              },
            )
          ],
          centerTitle: true,
          title: const Text('一覧'),
        ),
        body: const CardList(),
        bottomNavigationBar:
            BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            activeIcon: Icon(Icons.book_online),
            label: 'Book',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            activeIcon: Icon(Icons.business_center),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            activeIcon: Icon(Icons.school_outlined),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings_accessibility),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
          // データを元にListViewを作成
        ]));
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({Key? key}) : super(key: key);

  final name = 'aiueo';
  final textReason = 'kakikukeko';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ListTile(
              leading: ClipOval(
                child: Container(
                  color: Colors.blue,
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Text(
                      name.substring(0, 1),
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
              title: Text(name),
              subtitle: const Text('2 min ago'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    child: Text(
                      textReason,
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: const [
                _ContentCard(),
                _ContentCard(),
                _ContentCard(),
                _ContentCard(),
                _ContentCard(),
                _ContentCard(),
                _ContentCard(),
                _ContentCard(),
                _ContentCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _getTwitchAPI(Map<String,String> accessToken) async {
  
  var headers = {
    'Authorization': accessToken,
    'Client-Id': 'd5hwqf5jpal58uh7hct83bcdzqt1qw',
  };

  var params = {
    'broadcaster_id': '50988750',
  };
  var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

  var url = Uri.parse('https://api.twitch.tv/helix/channels?$query');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.get error: statusCode= ${res.statusCode}')
  }else{
    print(res.body);
  }
}

Future<Map<String, String>> _requestOauth() async {

  var header = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = 'client_id=d5hwqf5jpal58uh7hct83bcdzqt1qw&client_secret=csol10s2i5iy7iupfotoeboyrpcj6z&grant_type=client_credentials';

  var url = Uri.parse('https://id.twitch.tv/oauth2/token');
  var res = await http.post(url, headers: header, body: data);
  if (res.statusCode != 200){
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }else{
    Map<String,String> a=jsonDecode(res.toString());
    return a;
  }  
}