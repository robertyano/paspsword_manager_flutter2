import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/shared/constants.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  // form values
  late String _currentAccountName;
  late String _curretuserName;
  late String _currentPassword;
  late String _currentNotes;


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          Text(
            'Update Account Details',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(labelText: "Account Name"),
            validator: (val) => val!.isEmpty ? 'Please enter an account name' : null,
            onChanged: (val) => setState(() => _currentAccountName = val),
            ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(labelText: "Username"),
            validator: (val) => val!.isEmpty ? 'Please enter a username' : null,
            onChanged: (val) => setState(() => _curretuserName = val),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(labelText: "Password"),
            validator: (val) => val!.isEmpty ? 'Please enter a password' : null,
            onChanged: (val) => setState(() => _currentPassword = val),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(labelText: "Notes"),
            validator: (val) => val!.isEmpty ? '' : null,
            onChanged: (val) => setState(() => _currentNotes = val),
          ),


          SizedBox(height: 20.0,),
          ElevatedButton(
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print(_currentAccountName);
              print(_curretuserName);
              print(_currentPassword);
              print(_currentNotes);
            },
          ),
         ],
        ),
      );
    }
  }
