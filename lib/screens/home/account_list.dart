import 'package:flutter/material.dart';
import 'package:paspsword_manager_flutter2/models/account.dart';
import 'package:provider/provider.dart';
import 'package:paspsword_manager_flutter2/screens/home/account_tile.dart';

class AccountList extends StatefulWidget {
  const AccountList({super.key});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {

    final accounts = Provider.of<List<Account>?>(context);



      return ListView.builder(
        itemCount: accounts?.length,
        itemBuilder: (context, index) {
          return AccountTile(account: accounts![index]);
        },
      );
    }
  }

