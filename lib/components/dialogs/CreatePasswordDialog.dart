import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe/components/forms/createPasswordForm.dart';
import 'package:safe/components/shared/TextStyles.dart' as TextStyles;

class CreatePasswordDialog extends StatefulWidget {
  final String title;

  const CreatePasswordDialog({Key key, this.title}) : super(key: key);

  @override
  _CreatePasswordDialogState createState() => _CreatePasswordDialogState();
}

class _CreatePasswordDialogState extends State<CreatePasswordDialog> {
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
                alignment: Alignment.center,
                child: Text(widget.title, style: TextStyles.TITLE_TEXT_STYLE),
              ),
              SizedBox(
                height: 15,
              ),
              CreatePasswordForm()
            ],
          ),
        )
      ],
    );
  }
}
