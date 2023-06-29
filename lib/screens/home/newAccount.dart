import 'package:paspsword_manager_flutter2/services/auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';


class AddAccountDialog extends StatefulWidget {
  @override
  _AddAccountDialogState createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name ='';
  String _username = '';
  String _sitePassword ='';
  String _notes ='';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Account"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter the name of the account.";
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Username"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter the username of the account.";
                }
                return null;
              },
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter the password of the account.";
                }
                return null;
              },
              onSaved: (value) => _sitePassword = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Notes"),
              onSaved: (value) => _notes = value!,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text("Save"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(
                Account_old_original(
                  name: _name,
                  username: _username,
                  sitePassword: _sitePassword,
                  notes: _notes,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
