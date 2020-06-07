import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final myFocusNode = FocusNode();
final myController = TextEditingController();
String newName;
String newPassword;

class addPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新しいパスワードを登録'),
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: myController,
              focusNode: myFocusNode,
              enabled: true,
              maxLengthEnforced: false,
              obscureText: false,
              autovalidate: false,
              decoration: const InputDecoration(
                hintText: '表示名を入力',
                labelText: '名前 *',
              ),
              onChanged: (newNameText) {
                newName = newNameText;
                print(newNameText);
              },
            ),
            TextFormField(
              enabled: true,
              maxLengthEnforced: false,
              obscureText: false,
              autovalidate: false,
              decoration: const InputDecoration(
                hintText: 'パスワードを入力',
                labelText: 'パスワード *',
              ),
              onChanged: (newPasswordText) {
                newPassword = newPasswordText;
                print(newPasswordText);
              },

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('登録'),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString(newName, newPassword);
                    print(newName);
                    print(newPassword);                  },
                ),
                RaisedButton(
                  child: Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}