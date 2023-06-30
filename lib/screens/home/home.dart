import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paspsword_manager_flutter2/screens/home/settings_form.dart';
import 'package:paspsword_manager_flutter2/services/auth.dart';
import 'package:flutter/material.dart';
import 'newAccount.dart';
import 'package:paspsword_manager_flutter2/services/database.dart';
import 'package:provider/provider.dart';
import 'package:paspsword_manager_flutter2/screens/home/account_list.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  List<Account_old_original> _account = [];

  void _addAccount(String name, String email, String sitePassword, String notes) {
    setState(() {
      _account.add(Account_old_original(name: name, username: email, sitePassword: sitePassword, notes: notes));
    });
  }


  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(uid: FirebaseAuth.instance.currentUser!.uid),
        );
      });
    }

    return StreamProvider<List<Account>?>.value(
      value: DatabaseService(uid: '').accounts,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          /*title: Align(
              alignment: Alignment.centerLeft,
              child: Text('Password Secure Kiwi', textAlign: TextAlign.left)),*/
          elevation: 0.0,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout',),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            ElevatedButton.icon(
              icon: Icon (Icons.add),
              label: Text('Add Account'),
              onPressed: () => _showSettingsPanel(),
            ),


            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Account'),
              onPressed: () async {
                // Show a dialog or a bottom sheet to get the details of the new account
                final account = await showDialog<Account_old_original>(
                  context: context,
                  builder: (context) {
                    return AddAccountDialog();
                  },
                );
                if (account != null) {
                  _addAccount(account.name, account.username, account.sitePassword, account.notes);
                }
              },
            ),
          ],
        ),

       body: AccountList(),

        // original list view, which may be deprecated
       /* body: ListView.builder(
          itemCount: _account.length,
          itemBuilder: (context, index) {
            Account account = _account[index];
            return AccountCard(account: account);
         },
        ),*/

      ),
    );
  }
}


class Account_old_original {
  final String name;
  final String username;
  final String sitePassword;
  final String notes;

  Account_old_original({required this.name, required this.username, required this.sitePassword, required this.notes});
}

class AccountCard extends StatefulWidget {
  final Account_old_original account;

  AccountCard({required this.account});

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  // Remove the unnecessary _account getter
  get _account => null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(widget.account.name),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Username: " + widget.account.username),
                    Text("Password: " + widget.account.sitePassword),
                    Text("Notes: " + widget.account.notes),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text("Edit"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Show the dialog to edit the account details
                    showDialog<Account_old_original>(
                      context: context,
                      builder: (context) {
                        return EditAccountDialog(account: widget.account);
                      },
                    ).then((newAccount) {
                      setState(() {
                        int index = _account.indexOf(widget.account);
                        _account[index] = newAccount;
                      });
                    });
                  },
                ),
              ],
            );
          },
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.account.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.account.username),
            ],
          ),
        ),
      ),
    );
  }
}


class EditAccountDialog extends StatefulWidget {
  late final Account_old_original account;

  EditAccountDialog({required this.account});

  @override
  _EditAccountDialogState createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends State<EditAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late Account_old_original _account;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;

  @override
  void initState() {

    late DatabaseService _databaseService;

    @override
    void initState() {
      super.initState();
      _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    }


    // Old code, remove when new ListView is working
   /* super.initState();
    _account = widget.account;
    _nameController = TextEditingController(text: widget.account.name);
    _emailController = TextEditingController(text: widget.account.username);
    _passwordController = TextEditingController(text: widget.account.sitePassword);
    _notesController = TextEditingController(text: widget.account.notes)*/;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Account"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an email";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a password";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: "Notes"),
              ),
            ],
          ),
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
              // _formKey.currentState!.save();
              Navigator.of(context).pop(Account_old_original(
                name: _nameController.text,
                username: _emailController.text,
                sitePassword: _passwordController.text,
                notes: _notesController.text,));
            }

          },
        ),
      ],
    );
  }
}