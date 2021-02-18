import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe/components/shared/TextStyles.dart' as TextStyles;
import 'package:safe/models/PasswordModel.dart';

import '../forms/CreatePasswordForm.dart';

class ModifyPasswordDialog extends StatefulWidget {
  final String title;
  final PasswordModel pw;

  const ModifyPasswordDialog({Key key, this.title, this.pw}) : super(key: key);

  @override
  _ModifyPasswordDialogState createState() => _ModifyPasswordDialogState();
}

class _ModifyPasswordDialogState extends State<ModifyPasswordDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 8, left: 12, right: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 2), blurRadius: 5),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(widget.title, style: TextStyles.TITLE_TEXT_STYLE),
              ),
              SizedBox(
                height: 15,
              ),
              CreatePasswordForm(pw: widget.pw)
            ],
          ),
        )
      ],
    );
  }
}
