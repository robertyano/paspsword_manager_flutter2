import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/shared/constants.dart';
import 'package:paspsword_manager_flutter2/services/database.dart';

class SettingsForm extends StatefulWidget {
  //const SettingsForm({super.key});

  final String uid;

  const SettingsForm({Key? key, required this.uid}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState(uid: uid);

}

class _SettingsFormState extends State<SettingsForm> {

  final String uid;  // added to accept uid
  _SettingsFormState({required this.uid});

  final _formKey = GlobalKey<FormState>();
  // creating instance of 'DatabaseService' with user's ID
  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid); // update UID to be dynamic

  // form values
  late String _currentAccountName;
  late String _curretuserName;
  late String _currentPassword;
  String _currentNotes = ''; // Initialize to an empty string because this is not a required field


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          Text(
            'Add New Account',
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
            // validator: (val) => val!.isEmpty ? '' : null,
            onChanged: (val) => setState(() => _currentNotes = (val.isEmpty ? null : val)!),

          ),


          SizedBox(height: 20.0,),
          ElevatedButton(
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              /*print(_currentAccountName);
              print(_curretuserName);
              print(_currentPassword);
              print(_currentNotes);*/
              if (_formKey.currentState!.validate()) {
                await _databaseService.updateUserData(_currentAccountName, _curretuserName, _currentPassword, _currentNotes);
                print('Account Updated');
                // SettingsForm(uid: uid); // updated build
                Navigator.pop(context);  // Close the bottom sheet
              }

            },
          ),
         ],
        ),
      );
    }
  }
