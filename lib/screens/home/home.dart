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
  late final DatabaseService databaseService;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      databaseService = DatabaseService(uid: currentUser.uid);
    }
  }

  void _deleteAccount() async {
    bool success = await _auth.deleteAccount();
    if (success) {
      // Account deleted successfully, perform additional actions if needed
    } else {
      // Failed to delete account, handle the error
    }
  }


  void _showSettingsPanel(Account account) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(account: account, uid: FirebaseAuth.instance.currentUser!.uid),
        );
      },
    );
  }

  void _deleteSngleAccount(Account account) async {
    await databaseService.deleteAccount(account.documentId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamProvider<List<Account>?>.value(
      value: databaseService.accounts,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Account'),
              onPressed: () {
                Account newAccount = Account(accountName: '', password: '', notes: '', userName: '', documentId: '');
                _showSettingsPanel(newAccount);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Delete Account'),
                onTap: () {
                  // Perform action for Settings Option 1
                  _deleteAccount();
                },
              ),

              /*ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings Option 2'),
                onTap: () {
                  // Perform action for Settings Option 2
                },
              ),
              // Add more ListTile widgets for additional settings options*/
            ],
          ),
        ),
        body: AccountList(
          onAccountSelected: (account) {
            _showSettingsPanel(account);
          },
          onDeleteAccount: (account) {
            _deleteSngleAccount(account);
          },
        ),
      ),
    );
  }
}
