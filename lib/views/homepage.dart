import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:safe/components/PasswordsListView.dart';
import 'package:safe/models/SortingOptions.dart';
import 'package:safe/components/dialogs/CreatePasswordDialog.dart';
import 'package:safe/components/dialogs/ExportPaswordsDialog.dart';
import 'package:provider/provider.dart';
import 'package:safe/providers/CredentialsProvider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SortingOptions selected = SortingOptions.DATE_DSC;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.sort),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("Sorting Options"),
                value: null,
              ),
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(selected == SortingOptions.NAME_ASC
                          ? Icons.check
                          : Icons.sort_by_alpha),
                      title: Text("Website (A - Z)")),
                  value: SortingOptions.NAME_ASC),
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(selected == SortingOptions.NAME_DESC
                          ? Icons.check
                          : Icons.sort_by_alpha),
                      title: Text("Website (Z - A)")),
                  value: SortingOptions.NAME_DESC),
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(selected == SortingOptions.DATE_DSC
                          ? Icons.check
                          : Icons.arrow_downward_rounded),
                      title: Text("Last Modified")),
                  value: SortingOptions.DATE_DSC),
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(selected == SortingOptions.DATE_ASC
                          ? Icons.check
                          : Icons.arrow_upward_rounded),
                      title: Text("Last Modified")),
                  value: SortingOptions.DATE_ASC),
            ],
            onSelected: (route) async {
              setState(() {
                selected = route;
              });
              switch (route) {
                case SortingOptions.DATE_ASC:
                case SortingOptions.DATE_DSC:
                case SortingOptions.NAME_DESC:
                case SortingOptions.NAME_ASC:
                  context.read<CredentialsProvider>().updateSorting(route);
                  break;
                default:
                  break;
              }
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.download_sharp),
                      title: Text("Export to file"),
                      onTap: () async {
                        Navigator.pop(context);
                        if (await context
                            .read<CredentialsProvider>()
                            .verifyUser("Authenticate to proceed")) {
                          var code = await context
                              .read<CredentialsProvider>()
                              .exportToFile();
                          if (code != null && code.isNotEmpty)
                            showExportDialog(code);
                        }
                      }),
                  value: null),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: context.read<CredentialsProvider>().init(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: PasswordsListBuilder());
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
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

  void showExportDialog(String code) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ExportPasswordsDialog(code: code);
        });
  }
}
