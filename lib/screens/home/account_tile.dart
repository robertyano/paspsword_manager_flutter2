import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';

class AccountTile extends StatelessWidget {
  final Account account;
  final Function(Account) onAccountSelected;
  final Function(Account) onDeleteAccount;

  AccountTile({required this.account, required this.onAccountSelected, required this.onDeleteAccount});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(account.documentId),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete this account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('DELETE'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) => onDeleteAccount(account),
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.red,
              backgroundImage: AssetImage('assets/evil_kiwi_bird_tattoo_design.png'),
            ),
            title: Text(
                '${account.accountName}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('${account.userName}'),
            onTap: () => onAccountSelected(account),
          ),
        ),
      ),
    );
  }
}
