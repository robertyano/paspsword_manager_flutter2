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
  // List<Account_old_original> _account = [];
  late final DatabaseService databaseService; // Define databaseService here

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      databaseService = DatabaseService(uid: currentUser.uid);
    }
  }


  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(Account account) {
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(account: account, uid: FirebaseAuth.instance.currentUser!.uid),
        );
      });
    }

    final currentUser = FirebaseAuth.instance.currentUser;


    return StreamProvider<List<Account>?>.value(
      value: databaseService.accounts,
      //value: DatabaseService(uid: '').accounts,
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
              onPressed: () {
                // Create a new account with empty fields
                Account newAccount = Account(accountName: '', password: '', notes: '', userName: '', documentId: '');
                _showSettingsPanel(newAccount);
              },
            ),



          ],
        ),

       body: AccountList(
         onAccountSelected: (account) {
           _showSettingsPanel(account);
         },
       ),


      ),
    );
  }
}



