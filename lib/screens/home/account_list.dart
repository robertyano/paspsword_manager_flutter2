import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';
import 'package:provider/provider.dart';
import 'package:paspsword_manager_flutter2/screens/home/account_tile.dart';

class AccountList extends StatefulWidget {
  final Function(Account) onAccountSelected;
  final Function(Account) onDeleteAccount; // Add onDeleteAccount callback

  AccountList({required this.onAccountSelected, required this.onDeleteAccount, Key? key}) : super(key: key);

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<List<Account>?>(context);

    if (accounts == null) {
      return CircularProgressIndicator(); // show a loading spinner
    } else {
      // Sort the list of accounts based on the account name in alphabetical order
      accounts.sort((a, b) => a.accountName.compareTo(b.accountName));

      return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return AccountTile(
            account: accounts[index],
            onAccountSelected: widget.onAccountSelected,
            onDeleteAccount: widget.onDeleteAccount, // Pass the onDeleteAccount callback
          );
        },
      );
    }
  }
}
