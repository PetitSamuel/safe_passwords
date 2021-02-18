import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe/components/shared/TextStyles.dart' as TextStyles;
import 'package:safe/components/shared/URLHelper.dart';
import 'package:safe/models/CredentialActions.dart';
import 'package:safe/models/PasswordModel.dart';
import 'package:flutter/services.dart';

import 'dialogs/ConfirmDeleteCredentialDialog.dart';
import 'dialogs/ModifyPasswordDialog.dart';

class SingleCredentialTile extends StatefulWidget {
  final PasswordModel pw;
  final String timeSinceModified;

  SingleCredentialTile({Key key, this.pw, this.timeSinceModified})
      : super(key: key);

  @override
  _SingleCredentialTileState createState() => _SingleCredentialTileState();
}

class _SingleCredentialTileState extends State<SingleCredentialTile> {
  bool showPassword = false;

  copyToClipboard(String value) {
    Clipboard.setData(new ClipboardData(text: value));
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Copied to clipboard!')));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.lock_outline_rounded, size: 30),
      title: new Text(widget.pw.website),
      subtitle: Text(widget.timeSinceModified),
      children: <Widget>[
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.copy_rounded),
                            tooltip: 'Copy to clipboard',
                            onPressed: () =>
                                {copyToClipboard(widget.pw.username)},
                          ),
                          IconButton(
                            icon: Icon(Icons.person),
                            tooltip: 'Username',
                            onPressed: () => {},
                          ),
                          Text(widget.pw.username,
                              style: TextStyles.CREDENTIAL_DETAILS_TEXT),
                        ]),
                    SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      IconButton(
                        icon: Icon(Icons.copy_rounded),
                        tooltip: 'Copy to clipboard',
                        onPressed: () => {
                          // TODO : add auth check
                          copyToClipboard(widget.pw.password)
                        },
                      ),
                      IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        tooltip:
                            showPassword ? 'Hide password' : 'Show password',
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                      Text(
                          showPassword
                              ? widget.pw.password
                              : widget.pw.password
                                  .replaceAll(new RegExp(r'.'), "•"),
                          style: TextStyles.CREDENTIAL_DETAILS_TEXT),
                    ]),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.update),
                          SizedBox(width: 8),
                          Text("Modify")
                        ],
                      ),
                      value: CredentialActions.MODIFY),
                  PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.delete_forever),
                          SizedBox(width: 8),
                          Text("Remove")
                        ],
                      ),
                      value: CredentialActions.REMOVE),
                  isValidUrl(widget.pw.website)
                      ? PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.link),
                              SizedBox(width: 8),
                              Text("Visit website")
                            ],
                          ),
                          value: CredentialActions.LAUNCH_WEBSITE)
                      : null,
                ],
                onSelected: (route) async {
                  switch (route) {
                    case CredentialActions.MODIFY:
                      showModifyPasswordDialog(widget.pw);
                      break;
                    case CredentialActions.REMOVE:
                      showConfirmDeleteDialog(widget.pw.website);
                      break;
                    case CredentialActions.LAUNCH_WEBSITE:
                      await launchInBrowser(widget.pw.website);
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Visibility(
          visible: false,
          child: Text("test"),
        ),
      ],
    );
  }

  void showConfirmDeleteDialog(String website) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteCredentialDialog(website: website);
        });
  }

  void showModifyPasswordDialog(PasswordModel pw) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ModifyPasswordDialog(pw: pw, title: 'Modify Credentials');
        });
  }
}
