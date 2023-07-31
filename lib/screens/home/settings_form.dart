import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/shared/constants.dart';
import 'package:paspsword_manager_flutter2/services/database.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';


class SettingsForm extends StatefulWidget {
  //const SettingsForm({super.key});

  final String uid;
  final Account account;

  SettingsForm({required this.uid, required this.account});
  //const SettingsForm({Key? key, required this.uid}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState(uid: uid);

}

class _SettingsFormState extends State<SettingsForm> {

  final String uid;  // added to accept uid
  _SettingsFormState({required this.uid});

  final _formKey = GlobalKey<FormState>();
  // creating instance of 'DatabaseService' with user's ID
  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid); // update UID to be dynamic

  final passwordController = TextEditingController();

  // form values
  late String _currentAccountName;
  late String _currentUserName;
  late String _currentPassword;
  String _currentNotes = ''; // Initialize to an empty string because this is not a required field

  bool _isPasswordDecrypted = false;

  @override
  void initState() {
    super.initState();
    // Initialize form values if a new account is being created
    _currentAccountName = widget.account.accountName;
    _currentUserName = widget.account.userName;
    _currentPassword = widget.account.password;
    if (!_isPasswordDecrypted) {
      _decryptPassword();
    }
    _currentNotes = widget.account.notes;

  }

  _decryptPassword() async {
    String? decryptedPassword = await _databaseService.decryptPassword(widget.account.password);
    if (decryptedPassword != null) {
      setState(() {
        print("Settings_form.dart password enter decryption step");
        _currentPassword = decryptedPassword;
        print("Settings_form.dart decrypted password is: " + _currentPassword);
        passwordController.text = _currentPassword;
        _isPasswordDecrypted = true;
      });
    } else {
      print("Settings_form.dart password not decrypted");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(  // <-- And this
      padding: EdgeInsets.only(
      top: 8.0,
      left: 8.0,
      right: 8.0,
      bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
    ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget> [
            Text(
              'Add New Account',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0,),
            TextFormField(
              initialValue: widget.account.accountName,
              decoration: InputDecoration(labelText: "Account Name"),
              validator: (val) => val!.isEmpty ? 'Please enter an account name' : null,
              onChanged: (val) => setState(() => _currentAccountName = val),
              ),
            SizedBox(height: 20.0,),
            TextFormField(
              initialValue: widget.account.userName,
              decoration: InputDecoration(labelText: "Username"),
              validator: (val) => val!.isEmpty ? 'Please enter a username' : null,
              onChanged: (val) => setState(() => _currentUserName = val),
            ),
            SizedBox(height: 20.0,),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              validator: (val) => val!.isEmpty ? 'Please enter a password' : null,
              onChanged: (val) {
                setState(() {
                  _currentPassword = val;
                  passwordController.text = val;  // Update the controller's text to the new value
                  passwordController.selection = TextSelection.fromPosition(
                    TextPosition(offset: passwordController.text.length),  // Move cursor to the end of the text
                  );
                });
              },
            ),

            SizedBox(height: 20.0,),
            TextFormField(
              initialValue: widget.account.notes,
              decoration: InputDecoration(labelText: "Notes"),
              // validator: (val) => val!.isEmpty ? '' : null,
              onChanged: (val) => setState(() => _currentNotes = (val.isEmpty ? null : val)!),

            ),


            SizedBox(height: 20.0,),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Cancel and go back
                    },
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Account updatedAccount = Account(
                          accountName: _currentAccountName,
                          userName: _currentUserName,
                          password: _currentPassword,
                          notes: _currentNotes,
                          documentId: widget.account.documentId,
                          encryptionKey: '', //widget.account.encryptionKey, // Use the documentId from the current account
                        );
                        await _databaseService.updateUserData(updatedAccount);
                        print('Account Updated');
                        Navigator.pop(context);  // Close the bottom sheet
                      }
                    },
                  ),
                ],
              ),
            ),

          ],
          ),
        ),
      ),
    );
    }
  }
