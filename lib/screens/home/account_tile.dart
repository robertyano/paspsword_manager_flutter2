import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';

class AccountTile extends StatelessWidget {
  // const AccountTile({super.key});

  final Account account;
  final Function(Account) onAccountSelected;

  AccountTile({required this.account, required this.onAccountSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.red,
            backgroundImage: AssetImage('assets/evil_kiwi_bird_tattoo_design.png'),
          ),
          title: Text('Account: ' + account.accountName),
          subtitle: Text('Username: ' + account.userName),
          onTap: () => onAccountSelected(account),
        ),
      )
    );
  }
}
