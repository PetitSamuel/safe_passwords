import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:safe/models/PasswordModel.dart';
import 'package:safe/providers/CredentialsProvider.dart';
import 'package:provider/provider.dart';

class CreatePasswordForm extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  final PasswordModel pw;

  CreatePasswordForm({Key key, this.pw}) : super(key: key);

  @override
  _CreatePasswordFormState createState() => _CreatePasswordFormState(pw);
}

class _CreatePasswordFormState extends State<CreatePasswordForm> {
  Map<String, String> formValues = {};
  TextEditingController passwordTextController = TextEditingController();

  _CreatePasswordFormState(PasswordModel pw) {
    passwordTextController.text = pw?.password;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            initialValue: widget.pw?.website,
            decoration: const InputDecoration(
              icon: Icon(Icons.link_rounded),
              labelText: 'Website',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Enter a valid website URL';
              }
              formValues["website"] = value;
              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            initialValue: widget.pw?.username,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Username',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Username cannot be empty';
              }
              formValues["username"] = value;
              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: passwordTextController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Password cannot be empty';
              }
              formValues["password"] = value;
              return null;
            },
          ),
          ButtonBar(
            children: [
              FlatButton(
                  child: Text('Generate Password'),
                  onPressed: () {
                    passwordTextController.text = randomString(10);
                  }),
              RaisedButton(
                onPressed: () async {
                  if (context.read<CredentialsProvider>().isLoading)
                    return null;
                  formValues.clear();
                  if (widget._formKey.currentState.validate()) {
                    await context.read<CredentialsProvider>().addPassword(
                        PasswordModel(
                            website: formValues["website"],
                            username: formValues["username"],
                            password: formValues["password"],
                            created: DateTime.now()));
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
