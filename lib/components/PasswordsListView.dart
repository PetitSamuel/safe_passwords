import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:safe/models/PasswordModel.dart';
import 'package:safe/providers/CredentialsProvider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'SingleCredentialPanel.dart';
import 'searchWidget.dart';

class PasswordsListBuilder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var passwords = context.watch<CredentialsProvider>().filteredPassword;

    return ListView.builder(
      itemCount: passwords.length + 1,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, i) {
        if (i == 0) {
          return SearchWidget();
        }
        PasswordModel pw = passwords[i - 1];
        final now = DateTime.now();
        final difference = now.difference(pw?.lastModified ?? pw.created);
        final timeAgoText =
            timeago.format(now.subtract(difference), locale: 'en');

        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleCredentialTile(pw: pw, timeSinceModified: timeAgoText)
            ],
          ),
        );
      },
    );
  }
}
