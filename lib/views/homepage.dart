import 'package:flutter/material.dart';
import 'package:safe/components/PasswordsListView.dart';
import 'package:safe/components/dialogs/CreatePasswordDialog.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PasswordsListBuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateDialog,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showCreateDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreatePasswordDialog(title: "Create a Password");
        });
  }
}
