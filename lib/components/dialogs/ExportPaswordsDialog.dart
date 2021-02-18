import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:safe/components/shared/TextStyles.dart' as TextStyles;
import 'package:safe/providers/CredentialsProvider.dart';
import 'package:provider/provider.dart';
import 'package:safe/components/shared/TextStyles.dart' as TextStyles;

class ExportPasswordsDialog extends StatefulWidget {
  final String code;

  const ExportPasswordsDialog({Key key, this.code}) : super(key: key);

  @override
  _ExportPasswordsDialogState createState() => _ExportPasswordsDialogState();
}

class _ExportPasswordsDialogState extends State<ExportPasswordsDialog> {
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
                    alignment: Alignment.center,
                    child: Text("Passwords Exported",
                        style: TextStyles.TITLE_TEXT_STYLE),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      "Your passwords were successfully exported to your device's Download folder. The file is encrypted using UTF-8 encoding and AES encryption."),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      "Save the following encryption key safely, it will not be stored anywhere: "),
                  SizedBox(height: 12),
                  SelectableText(widget.code,
                      style: TextStyles.CREDENTIAL_DETAILS_TEXT),
                  ButtonBar(
                    children: [
                      RaisedButton(
                          child: Text('OK'),
                          onPressed: () {
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
