import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passwordapp/add_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
Database db;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  creationDatabase();
  runApp(MyApp());
}

creationDatabase() async {
  final databaseName = 'my.db';
  final databasesPath = await getDatabasesPath();
  final dbPath = join(databasesPath, databaseName);
  final db = openDatabase(
    dbPath,
    version: 1,
    onCreate: (database, version) {
      return database.execute(
        "CREATE TABLE Passwords(id INTEGER PRIMARY KEY, displayName TEXT, password TEXT)",
      );
    },
  );
  return db;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password_app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'パスワード管理'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //TODO: DBからdisplayName,passwordのリストを取得
  //仮のデータベース
  final _listDisplayName = ['ama','face','goo','app'];
  final _listPassword = ['hoge1','hoge2','hoge3','hoge4','hoge5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, textAlign: TextAlign.center,),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _listDisplayName.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(_listDisplayName[index]),
                trailing: Wrap(
                  spacing: 8,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.content_copy),
                      onPressed: () {
                        final copiedPassword = ClipboardData(text: _listPassword[index]);
                        Clipboard.setData(copiedPassword);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: _didPushEditButton,
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  //TODO: Edit画面と処理の作成
  void _didPushEditButton() {
    print('didPushEditButton');
  }

}

class Passwords {
  int id;
  String displayName;
  String password;

  Passwords({
    this.id,
    this.displayName,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'password': password,
    };
  }
}

//DB挿入処理
Future<void> _insertPassword(Database db, String displayName, String password) async {
  var values = <String, dynamic>{
    'displayName': displayName,
    'password': password,
  };
  await db.insert('Passwords', values);
}

//DB取得処理
Future<List<Passwords>> _getAllPasswords(Database db) async{
  List<Map> results = await db.query('Passwords');
  return results.map((Map m) {
    int id = m['_id'];
    String displayName = m['displayName'];
    String password = m['password'];
  }).toList();
}

//DB更新処理
Future _updatePassword(Database db, int id, String displayName, String password) async {
  var values = <String, dynamic>{
    'displayName': displayName,
    'password': password,
  };
  await db.update('Passwords', values, where: '_id=?', whereArgs: [id]);
}

//DB削除処理
Future _deletePassword(Database db, Passwords passwords) async {
  await db.delete(
      'passwords',
      where: '_id=?',
      whereArgs: [passwords.id]
  );
}