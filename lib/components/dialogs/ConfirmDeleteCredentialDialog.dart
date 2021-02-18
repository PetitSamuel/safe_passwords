import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:safe/components/shared/TextStyles.dart' as TextStyles;
import 'package:safe/providers/CredentialsProvider.dart';
import 'package:provider/provider.dart';

class DeleteCredentialDialog extends StatefulWidget {
  final String website;

  const DeleteCredentialDialog({Key key, this.website}) : super(key: key);

  @override
  _DeleteCredentialDialogState createState() => _DeleteCredentialDialogState();
}

class _DeleteCredentialDialogState extends State<DeleteCredentialDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 8, left: 24, right: 24),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 2),
                        blurRadius: 5),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Delete Password?",
                        style: TextStyles.TITLE_TEXT_STYLE),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      "This action will permanently remove the password from the application."),
                  SizedBox(
                    height: 15,
                  ),
                  ButtonBar(
                    children: [
                      FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      RaisedButton(
                          child: Text('Confirm'),
                          onPressed: () async {
                            await context
                                .read<CredentialsProvider>()
                                .removePassword(widget.website);
                            Navigator.pop(context);
                          }),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
