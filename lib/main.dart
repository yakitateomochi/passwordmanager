import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passwordapp/add_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}
createDatabase() async {
  final databaseName = 'my.db';
  final databasesPath = await getDatabasesPath();
  final dbPath = join(databasesPath, databaseName);
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  return database;
}

void populateDb(Database database, int version) async {
  await database.execute(
      "CREATE TABLE Passwords("
      "id INTEGER PRIMARY KEY,"
      "name TEXT,"
      "password TEXT"
      ")"
  );
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
      home: MyHomePage(title: 'Password_app'),
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

  var _listTitle = ['ama','face','goo','app'];
  var _listPassword = ['hoge1','hoge2','hoge3','hoge4','hoge5'];

  void _didPushEditButton() {
    setState(() {
      print('pushed edit_button1');
    });
  }

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
        padding: EdgeInsets.all(0.0),
        itemCount: _listTitle.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(_listTitle[index]),
                trailing: Wrap(
                  spacing: 8,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.content_copy),
                      onPressed: () {
                        final coppiedtext = ClipboardData(text: _listPassword[index]);
                        Clipboard.setData(coppiedtext);
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
}
